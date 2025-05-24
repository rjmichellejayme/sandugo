import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:sandugo/saved_places_page.dart';
import 'hospital_details_page.dart';
import 'information_page.dart';
import 'hospital_data.dart';
import 'package:sandugo/saved_places_page.dart';

class NearestFacilitiesPanel extends StatefulWidget {
  const NearestFacilitiesPanel({super.key});

  @override
  State<NearestFacilitiesPanel> createState() => _NearestFacilitiesPageState();
}

class _NearestFacilitiesPageState extends State<NearestFacilitiesPanel> {
  List<Hospital> allHospitals = [];
  Position? currentLocation;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _getUserLocation();
    await _loadHospitals();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _loadHospitals() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('hospitals').get();
    final loaded = snapshot.docs.map((doc) {
      final data = doc.data();
      return Hospital(
        name: data['name'],
        address: data['address'],
        type: data['type'],
        location: LatLng(
          data['location'].latitude,
          data['location'].longitude,
        ),
        phone: data['phone'],
        bloodTypes: List<String>.from(data['bloodtype']),
        bloodComponents: List<String>.from(data['bloodcomponent']),
      );
    }).toList();

    loaded.sort((a, b) {
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

    allHospitals = loaded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: allHospitals.length,
              itemBuilder: (context, index) {
                final hospital = allHospitals[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.local_hospital, color: Colors.red),
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
                        IconButton(
                          icon: const Icon(Icons.bookmark_border,
                              color: Colors.red),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedPlacesPage(),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.info_outline, color: Colors.red),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InformationPage(),
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
    );
  }
}
