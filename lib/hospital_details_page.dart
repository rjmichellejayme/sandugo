// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'hospital_data.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

String capitalizeWords(String input) {
  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}

class HospitalDetailsPage extends StatelessWidget {
  final Hospital hospital;

  const HospitalDetailsPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Hospital Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFFD14E52), // Red title
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        elevation: 2, // subtle shadow
        backgroundColor: Colors.white, // White AppBar
        shadowColor: const Color(0xFFFF696E).withOpacity(0.2), // Optional: subtle red shadow
        iconTheme: const IconThemeData(color: Color(0xFFD14E52)), // Red back button
      ),
      backgroundColor: const Color(0xFFF9EDEC), // <-- Add this line
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Column(
              children: [
                const Icon(
                  Icons.local_hospital_rounded,
                  size: 60,
                  color: Color(0xFFD14E52),
                ),
                const SizedBox(height: 12),
                Text(
                  hospital.name,
                  style: const TextStyle(
                    color: Color(0xFF222222),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9EDEC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFF9598).withOpacity(0.5),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.07),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(hospital.location.latitude, hospital.location.longitude),
                          initialZoom: 16,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName: 'com.project.sandugo',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: LatLng(hospital.location.latitude, hospital.location.longitude),
                                width: 40,
                                height: 40,
                                alignment: Alignment.center,
                                child: Tooltip(
                                  message: hospital.name,
                                  child: const Icon(Icons.local_hospital, color: Colors.red, size: 40),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Optional: Center-on-hospital button
                  const Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.my_location, color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoCard(
                    context,
                    'Contact Information',
                    [
                      _buildInfoRow(Icons.phone, 'Phone', hospital.phone),
                      _buildInfoRow(Icons.location_on, 'Address', hospital.address),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Available Blood Types',
                    [
                      _buildInfoRow(
                        Icons.bloodtype,
                        'Types',
                        hospital.bloodTypes.map((bt) => capitalizeWords(bt)).join(", "),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    context,
                    'Available Components',
                    [
                      _buildInfoRow(
                        Icons.medical_services,
                        'Components',
                        hospital.bloodComponents.map((bt) => capitalizeWords(bt)).join(", "),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          border: Border.all(
            color: const Color(0xFFFF9598).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconForTitle(title),
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 24,
                color: Color(0xFFFF9598),
              ),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'Contact Information':
        return Icons.contact_phone;
      case 'Available Blood Types':
        return Icons.bloodtype;
      case 'Available Components':
        return Icons.medical_services;
      default:
        return Icons.info;
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.red.withOpacity(0.7)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
