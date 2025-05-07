import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sandugo/navbar.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SanDUGO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomNavBar(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> hospitals = [];
  bool locationPermissionGranted = false;

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
      setState(() {
        locationPermissionGranted = true;
      });
    } else {
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

  void _showTooltip(BuildContext context, String message) {
    final tooltip = Tooltip(
      message: message,
      child: Icon(Icons.info_outline),
    );
    final dynamic tooltipState = tooltip.createState();
    tooltipState.ensureTooltipVisible();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SanDUGO Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              // Navigate to map page
            },
            tooltip: 'Quick Map Access',
          ),
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {
              _showTooltip(context,
                  'How to use the app: \n1. Allow location access.\n2. Use the map to find hospitals.\n3. Tap on a hospital to call.');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (!locationPermissionGranted)
            Center(
                child: Text(
                    'Location permission is required to find nearby hospitals.')),
          if (hospitals.isEmpty)
            Center(child: CircularProgressIndicator())
          else
            Expanded(
              child: ListView.builder(
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
            ),
          ElevatedButton(
            onPressed: () async {
              // Logic to find the nearest hospital and make an emergency call
              if (hospitals.isNotEmpty) {
                String url =
                    'tel:${hospitals[0]['phone']}'; // Example: call the first hospital
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  print('Could not launch $url');
                }
              }
            },
            child: Text('Emergency Call'),
          ),
        ],
      ),
    );
  }
}
