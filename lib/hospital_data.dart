import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Hospital {
  final String name;
  final String type;
  final LatLng location;
  final String phone;
  final List<String> bloodTypes;
  final List<String> bloodComponents;

  Hospital({
    required this.name,
    required this.type,
    required this.location,
    required this.phone,
    required this.bloodTypes,
    required this.bloodComponents,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    final GeoPoint geo = json['location']; // this must be a Firestore GeoPoint
    return Hospital(
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'Unknown',
      location: LatLng(geo.latitude, geo.longitude),
      phone: json['phone'] ?? 'N/A',
      bloodTypes: List<String>.from(json['bloodtype'] ?? []),
      bloodComponents: List<String>.from(json['bloodcomponent'] ?? []),
    );
  }
}
