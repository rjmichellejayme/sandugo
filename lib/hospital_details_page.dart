import 'package:flutter/material.dart';
import 'hospital_data.dart';

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
        title: const Text('Hospital Details'), // Add const
      ),
      body: Column(
        children: [
          const SizedBox(height: 16), // Add const
          const Divider(), // Add const
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hospital.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 8),
                Text('Phone: ${hospital.phone}'),
                const SizedBox(height: 8),
                Text('Address: ${hospital.address}'),
                const SizedBox(height: 8),
                Text(
                    'Available Blood Types: ${hospital.bloodTypes.map((bt) => capitalizeWords(bt)).join(", ")}'),
                const SizedBox(height: 8),
                Text(
                    'Available Components: ${hospital.bloodComponents.map((bt) => capitalizeWords(bt)).join(", ")}'),
                // Add more details as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
