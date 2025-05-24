import 'package:latlong2/latlong.dart';

class Hospital {
  final String name;
  final String type;
  final LatLng location;
  final String phone;
  final String address;
  final List<String> bloodTypes;
  final List<String> bloodComponents;

  Hospital({
    required this.name,
    required this.type,
    required this.location,
    required this.phone,
    required this.address,
    required this.bloodTypes,
    required this.bloodComponents,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    final loc = json['location'] ?? {};
    return Hospital(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      location: LatLng(
        (loc['_latitude'] ?? 0.0) as double,
        (loc['_longitude'] ?? 0.0) as double,
      ),
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      bloodTypes: List<String>.from(json['bloodtype'] ?? []),
      bloodComponents: List<String>.from(json['bloodcomponent'] ?? []),
    );
  }
}
