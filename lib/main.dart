import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hospital App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HospitalList(),
    );
  }
}

class HospitalList extends StatefulWidget {
  @override
  _HospitalListState createState() => _HospitalListState();
}

class _HospitalListState extends State<HospitalList> {
  List<dynamic> hospitals = [];

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    loadHospitals().then((data) {
      setState(() {
        hospitals = data;
      });
    }).catchError((error) {
      print('Error loading hospitals: $error');
    });
  }

  Future<void> requestLocationPermission() async {
    PermissionStatus status = await Permission.location.request();
    if (status.isGranted) {
      // Proceed with location-based features
    } else {
      // Handle the case when permission is denied
      print('Location permission denied');
    }
  }

  Future<List<dynamic>> loadHospitals() async {
    try {
      String data = await rootBundle.loadString('assets/hospitals.json');
      List<dynamic> jsonData = json.decode(data);
      Position userLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<dynamic> nearbyHospitals = [];
      for (var hospital in jsonData) {
        double distance = Geolocator.distanceBetween(
          userLocation.latitude,
          userLocation.longitude,
          hospital['latitude'],
          hospital['longitude'],
        );
        if (distance <= 50000) {
          nearbyHospitals.add(hospital);
        }
      }
      return nearbyHospitals;
    } catch (e) {
      print('Error loading hospital data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospitals List'),
      ),
      body: hospitals.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: hospitals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(hospitals[index]['name']),
                  subtitle: Text('Phone: ${hospitals[index]['phone']}'),
                  onTap: () async {
                    String url = 'tel:${hospitals[index]['phone']}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      print('Could not launch $url');
                    }
                  },
                );
              },
            ),
    );
  }
}
