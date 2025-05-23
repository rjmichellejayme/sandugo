import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'SavedPlacesPage.dart';
import 'InformationPage.dart';
import 'HospitalDetailsPage.dart';
import 'hospital_data.dart';

// class Hospital {
//   final String name;
//   final String type;
//   final LatLng location;
//   final String phone;
//   final List<String> bloodTypes;
//   final List<String> bloodComponents;

//   Hospital({
//     required this.name,
//     required this.type,
//     required this.location,
//     required this.phone,
//     required this.bloodTypes,
//     required this.bloodComponents,
//   });

//   factory Hospital.fromJson(Map<String, dynamic> json) {
//     return Hospital(
//       name: json['name'],
//       type: json['type'],
//       location: LatLng(json['latitude'], json['longitude']),
//       phone: json['phone'],
//       bloodTypes: List<String>.from(json['bloodtype']),
//       bloodComponents: List<String>.from(json['bloodcomponent']),
//     );
//   }
// }

class FindBloodPage extends StatefulWidget {
  const FindBloodPage({super.key});

  @override
  State<FindBloodPage> createState() => _FindBloodPageState();
}

class FilteredHospitalsPage extends StatelessWidget {
  final List<Hospital> hospitals;
  final LatLng userLocation;

  const FilteredHospitalsPage({
    super.key,
    required this.hospitals,
    required this.userLocation,
  });

  @override
  Widget build(BuildContext context) {
    final panelController = PanelController();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: userLocation,
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.my_location,
                        color: Colors.blue, size: 40),
                  ),
                  ...hospitals.map(
                    (hospital) => Marker(
                      point: hospital.location,
                      width: 40,
                      height: 40,
                      child: Tooltip(
                        message: hospital.name,
                        child: const Icon(Icons.local_hospital,
                            color: Colors.red, size: 32),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SlidingUpPanel(
            controller: panelController,
            minHeight: 100,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            panel: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Nearest Facilities',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: hospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = hospitals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.local_hospital,
                              color: Colors.red),
                          title: Text(hospital.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hospital.type),
                              const SizedBox(height: 4),
                              Text('Open 24 hours',
                                  style: TextStyle(color: Colors.green[700])),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.bookmark_border,
                                    color: Colors.red),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SavedPlacesPage()),
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InformationPage()),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HospitalDetailsPage(hospital: hospital),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Optional Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FindBloodPageState extends State<FindBloodPage> {
  LatLng? currentLocation;
  List<Hospital> allHospitals = [];

  String? selectedBloodType;
  String? selectedComponent;

  final List<String> bloodTypes = [
    'All',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  final List<String> bloodComponents = [
    'All',
    'Whole Blood',
    'Plasma',
    'Platelets',
    'Red Cells'
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void showFilteredResults() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Results',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = filteredHospitals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          leading: const Icon(Icons.local_hospital,
                              color: Colors.red),
                          title: Text(hospital.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hospital.type),
                              const SizedBox(height: 4),
                              Text(
                                'Open 24 hours',
                                style: TextStyle(color: Colors.green[700]),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.bookmark_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/saved-places');
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline,
                                    color: Colors.red),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/information');
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _getUserLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
      await _loadHospitals();
    }
  }

  Future<void> _loadHospitals() async {
    final String response =
        await rootBundle.loadString('assets/hospitals.json');
    final List<dynamic> data = jsonDecode(response);
    setState(() {
      allHospitals = data.map((e) => Hospital.fromJson(e)).toList();
    });
  }

  List<Hospital> get filteredHospitals {
    if (currentLocation == null) return [];

    List<Hospital> matches = allHospitals.where((hospital) {
      final matchesBloodType = selectedBloodType == null ||
          selectedBloodType == 'All' ||
          hospital.bloodTypes
              .map((e) => e.toLowerCase())
              .contains(selectedBloodType!.toLowerCase());

      final matchesComponent = selectedComponent == null ||
          selectedComponent == 'All' ||
          hospital.bloodComponents
              .map((e) => e.toLowerCase())
              .contains(selectedComponent!.toLowerCase());

      return matchesBloodType && matchesComponent;
    }).toList();

    matches.sort((a, b) {
      double distanceA = Geolocator.distanceBetween(
        currentLocation!.latitude,
        currentLocation!.longitude,
        a.location.latitude,
        a.location.longitude,
      );

      double distanceB = Geolocator.distanceBetween(
        currentLocation!.latitude,
        currentLocation!.longitude,
        b.location.latitude,
        b.location.longitude,
      );

      return distanceA.compareTo(distanceB);
    });

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Custom Header
          const SizedBox(height: 8),
          // Location Section Title
          const Text('Location',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('SanDUGO uses GPS to find nearest locations.'),
          const SizedBox(height: 12),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Location',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.mic, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search your desired location or use your current location.',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          // Map Section with floating location button
          SizedBox(
            height: 200,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: currentLocation == null
                      ? Container(
                          color: Colors.grey[200],
                        )
                      : FlutterMap(
                          options: MapOptions(
                            initialCenter: currentLocation!,
                            initialZoom: 13,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              userAgentPackageName: 'com.project.sandugo',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: currentLocation!,
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.my_location,
                                      color: Colors.blue, size: 40),
                                ),
                                ...filteredHospitals.map((hospital) => Marker(
                                      point: hospital.location,
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      child: Tooltip(
                                        message: hospital.name,
                                        child: const Icon(Icons.local_hospital,
                                            color: Colors.red, size: 32),
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.my_location, color: Colors.red),
                      onPressed: _getUserLocation,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Blood Type Section
          const Text('Blood Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Select the needed blood type.'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Choose Blood Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: selectedBloodType,
              onChanged: (value) => setState(() => selectedBloodType = value),
              items: bloodTypes.map((type) {
                return DropdownMenuItem(
                    value: type,
                    child: Text(type == 'All' ? 'All' : 'Blood Type $type'));
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Blood Component Section
          const Text('Blood Component',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Select the required blood component.'),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                hintText: 'Choose Blood Component',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              value: selectedComponent,
              onChanged: (value) => setState(() => selectedComponent = value),
              items: bloodComponents.map((component) {
                return DropdownMenuItem(
                    value: component, child: Text(component));
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedBloodType = null;
                      selectedComponent = null;
                    });
                  },
                  child: const Text('Clear',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    List<Hospital> sortedHospitals = filteredHospitals;

                    if (currentLocation != null) {
                      sortedHospitals.sort((a, b) {
                        final distanceA = Geolocator.distanceBetween(
                          currentLocation!.latitude,
                          currentLocation!.longitude,
                          a.location.latitude,
                          a.location.longitude,
                        );
                        final distanceB = Geolocator.distanceBetween(
                          currentLocation!.latitude,
                          currentLocation!.longitude,
                          b.location.latitude,
                          b.location.longitude,
                        );
                        return distanceA.compareTo(distanceB);
                      });

                      if (sortedHospitals.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilteredHospitalsPage(
                              hospitals: sortedHospitals,
                              userLocation: currentLocation!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("No matching facilities found.")),
                        );
                      }
                    }
                  },
                  child: const Text('Apply',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
