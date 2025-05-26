import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  final String id;
  final String name;
  final String type;
  final LatLng location;
  final String phone;
  final List<String> bloodTypes;
  final List<String> bloodComponents;
  final String address;

  Hospital({
    required this.id, // Unique identifier for the hospital
    required this.name,
    required this.type,
    required this.location,
    required this.phone,
    required this.bloodTypes,
    required this.bloodComponents,
    required this.address,
  });

  factory Hospital.fromJson(Map<String, dynamic> json, String id) {
    final GeoPoint geo = json['location'];
    return Hospital(
      id: id,
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      location: LatLng(geo.latitude, geo.longitude),
      phone: json['phone'] ?? 'N/A',
      bloodTypes: List<String>.from(json['bloodtype'] ?? []),
      bloodComponents: List<String>.from(json['bloodcomponent'] ?? []),
      address: json['address'] ?? 'N/A',
    );
  }

// Convert a Hospital instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'location': GeoPoint(location.latitude, location.longitude),
      'phone': phone,
      'bloodtype': bloodTypes,
      'bloodcomponent': bloodComponents,
      'address': address,
    };
  }
}

Future<void> saveHospitalToUserData(String userId, Hospital hospital) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);
  final savedHospitals = userDoc.collection('saved_hospitals');
  await savedHospitals.doc(hospital.id).set(hospital.toJson());
}