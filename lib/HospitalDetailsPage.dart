import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'hospital_data.dart'; // or wherever your Hospital class is

class HospitalDetailsPage extends StatelessWidget {
  final Hospital hospital;

  const HospitalDetailsPage({super.key, required this.hospital});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hospital.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${hospital.type}'),
            SizedBox(height: 8),
            Text('Phone: ${hospital.phone}'),
            SizedBox(height: 8),
            Text('Available Blood Types: ${hospital.bloodTypes.join(", ")}'),
            SizedBox(height: 8),
            Text(
                'Available Components: ${hospital.bloodComponents.join(", ")}'),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
