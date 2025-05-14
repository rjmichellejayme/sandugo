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
    return Hospital(
      name: json['name'],
      type: json['type'],
      location: LatLng(json['latitude'], json['longitude']),
      phone: json['phone'],
      bloodTypes: List<String>.from(json['bloodtype']),
      bloodComponents: List<String>.from(json['bloodcomponent']),
    );
  }
}
