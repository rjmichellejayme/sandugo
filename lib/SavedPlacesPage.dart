import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'hospital_data.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  // TODO: Replace with actual saved hospitals from local storage
  List<Hospital> savedHospitals = [];

  @override
  Widget build(BuildContext context) {
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.bookmark, color: Colors.red),
                                    onPressed: () {
                                      // TODO: Implement remove from saved places
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.info_outline, color: Colors.red),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/information');
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      // TODO: Implement remove from saved places
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
