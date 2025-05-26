import 'package:cloud_firestore/cloud_firestore.dart' show FirebaseFirestore;
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' show Geolocator, LocationAccuracy, Position;
import 'package:latlong2/latlong.dart' show LatLng;
import 'package:sandugo/hospital_details_page.dart' show HospitalDetailsPage;
import 'hospital_data.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  String? userId = FirebaseAuth.instance.currentUser?.uid;
  List<Hospital> savedHospitals = [];
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

  Future<void> _deleteHospital(String hospitalId) async {
    if (userId == null) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('saved_hospitals')
        .doc(hospitalId)
        .delete();

    setState(() {
      savedHospitals.removeWhere((h) => h.id == hospitalId);
    });
  }

  Future<void> _getUserLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _loadHospitals() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).collection('saved_hospitals').get();
    final loaded = snapshot.docs.map((doc) {
      final data = doc.data();
      return Hospital(
        id: doc.id, // Use the document ID as the unique identifier
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

    savedHospitals = loaded;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFBEAEA),
        body: Center(
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.red),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFFFBEAEA),
      body: Column(
        children: [
          Expanded(
            child: savedHospitals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No saved hospitals yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save hospitals to access them quickly',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: savedHospitals.length,
                    itemBuilder: (context, index) {
                      final hospital = savedHospitals[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.local_hospital,
                                color: Colors.red,
                                size: 32,
                              ),
                              title: Text(
                                hospital.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(hospital.type),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Available Blood Types: ${hospital.bloodTypes.join(", ")}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  // VIEW DETAILS BUTTON
                                  IconButton(
                                    icon: const Icon(Icons.info_outline,
                                        color: Colors.red),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HospitalDetailsPage(hospital: hospital),
                                        ),
                                      );
                                    },
                                  ),
                                  // DELETION BUTTON
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Remove Saved Hospital'),
                                          content: Text('Are you sure you want to remove ${hospital.name}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, false),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.pop(context, true),
                                              child: const Text('Remove', style: TextStyle(color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        await _deleteHospital(hospital.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('${hospital.name} removed from saved places')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
