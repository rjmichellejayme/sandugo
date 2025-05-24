import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart'; // Remove if unused
import 'hospital_data.dart'; // or wherever your Hospital class is

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
          const Divider(),            // Add const
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${hospital.type}'),
                const SizedBox(height: 8), // Add const
                Text('Phone: ${hospital.phone}'),
                const SizedBox(height: 8), // Add const
                Text('Available Blood Types: ${hospital.bloodTypes.join(", ")}'),
                const SizedBox(height: 8), // Add const
                Text(
                    'Available Components: ${hospital.bloodComponents.join(", ")}'),
                // Add more details as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
