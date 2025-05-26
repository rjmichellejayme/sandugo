import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'saved_places_page.dart';
import 'information_page.dart';
import 'hospital_details_page.dart';
import 'hospital_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FindBloodPage extends StatefulWidget {
  final VoidCallback? onShowSavedPlaces;
  const FindBloodPage({super.key, this.onShowSavedPlaces});

  @override
  State<FindBloodPage> createState() => _FindBloodPageState();
}

class FilteredHospitalsPage extends StatelessWidget {
  final VoidCallback? onShowSavedPlaces;
  final List<Hospital> hospitals;
  final LatLng userLocation;

  const FilteredHospitalsPage({
    super.key,
    required this.hospitals,
    required this.userLocation,
    this.onShowSavedPlaces,
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
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                  style: TextStyle(color: Colors.green)),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Saved Places
                              IconButton(
                                icon: const Icon(Icons.bookmark_border,
                                    color: Colors.red),
                                onPressed: () {
                                  Navigator.pop(context);
                                    if (onShowSavedPlaces != null) {
                                      onShowSavedPlaces!();
                                    } 
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
                                          const InformationPage(),
                                    ),
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

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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

  Hospital? _selectedHospital;
  final MapController _mapController = MapController();

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
                                icon: const Icon(
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
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('hospitals').get();
      print('Fetched ${snapshot.docs.length} hospitals');

      setState(() {
        allHospitals = snapshot.docs.map((doc) {
          final data = doc.data();
          print('Hospital Data: $data');
          return Hospital.fromJson(data);
        }).toList();
      });
    } catch (e, stack) {
      print('❌ Error loading hospitals: $e');
      print(stack);
    }
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

      final matchesSearch = _searchQuery.isEmpty ||
          hospital.name.toLowerCase().contains(_searchQuery.toLowerCase());
      // You can add more fields here, e.g. hospital.address

      return matchesBloodType && matchesComponent && matchesSearch;
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
      backgroundColor: const Color(0xFFF9EDEC),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        children: [
          // Custom Header
          const SizedBox(height: 8),
          // Location Section Title
          const Text('Location',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('SanDUGO uses GPS to find nearest locations.',
              style: TextStyle(fontSize: 14, color: Colors.black)),

          const SizedBox(height: 12),
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
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
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search Location',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.trim();
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _selectedHospital = null;
                    });
                    // Move map back to user's current location and default zoom
                    if (currentLocation != null) {
                      _mapController.move(currentLocation!, 13);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Search your desired location or use your current location.',
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          const SizedBox(height: 10),

          // --- Place the search results dropdown here ---
          if (_searchQuery.isNotEmpty && filteredHospitals.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredHospitals.length,
                itemBuilder: (context, index) {
                  final hospital = filteredHospitals[index];
                  return ListTile(
                    title: Text(hospital.name),
                    subtitle: Text(hospital.type),
                    onTap: () {
                      setState(() {
                        _selectedHospital = hospital;
                        _searchController.text = hospital.name;
                        _searchQuery = hospital.name;
                      });
                      // Animate map to hospital location
                      _mapController.move(hospital.location, 16);
                    },
                  );
                },
              ),
            ),
          // --- End search results dropdown ---

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
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter:
                                _selectedHospital?.location ?? currentLocation!,
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
                                        child: Icon(
                                          Icons.local_hospital,
                                          color: _selectedHospital == hospital
                                              ? Colors.blue
                                              : Colors.red,
                                          size: 32,
                                        ),
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
          const Text('Select the needed blood type.',
              style: TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              dropdownColor: Colors.white, 
              value: selectedBloodType,
              onChanged: (value) => setState(() => selectedBloodType = value),
              items: bloodTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    type == 'All' ? 'All' : 'Blood Type $type',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF434343),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Blood Component Section
          const Text('Blood Component',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Select the required blood component.',
              style: TextStyle(fontSize: 14, color: Colors.black)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
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
                    backgroundColor: const Color(0xFFD14E52),
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
                              onShowSavedPlaces: widget.onShowSavedPlaces,
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
