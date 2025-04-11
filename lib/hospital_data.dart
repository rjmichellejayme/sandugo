import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

Future<List<dynamic>> loadHospitals() async {
  // Load the JSON file as a string
  final String response =
      await rootBundle.rootBundle.loadString('assets/hospitals.json');
  // Decode the JSON string into a List
  final List<dynamic> hospitals = json.decode(response);
  return hospitals;
}
