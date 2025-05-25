import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:sandugo/find_blood_page.dart';
import 'package:sandugo/home_page.dart';
import 'package:sandugo/nearest_facilities_page.dart';
import 'package:sandugo/information_page.dart';
import 'package:sandugo/saved_places_page.dart';
import 'hospital_data.dart'; // Make sure this is imported

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;
  bool _isFirstLoad = true;
  bool _showNearestFacilities = false;

  List<Hospital> hospitals = [];
  LatLng? currentLocation;

  List<Widget> widgetOptions = <Widget>[
    const FindBloodPage(),
    const SavedPlacesPage(),
    const InformationPage(),
  ];

  final List<String> pageTitles = [
    "Filters",
    "Saved Places",
    "FAQs",
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocationAndHospitals();
  }

  Future<void> _getUserLocationAndHospitals() async {
    // Get location permission and current location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
      });
    }

    // Load hospitals from assets
    try {
      final String response = await rootBundle.loadString('assets/hospitals.json');
      final List<dynamic> data = jsonDecode(response);
      setState(() {
        hospitals = data.map((e) => Hospital.fromJson(e)).toList();
      });
    } catch (e) {
      // Handle error, e.g. show a message or log
      debugPrint('Error loading hospitals.json: $e');
    }
  }

  //Function to select on List
  void _onItemTap(int index) {
    setState(() {
      _currentIndex = index;
      _isFirstLoad = false;
      _showNearestFacilities = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (_showNearestFacilities) {
      bodyContent = const NearestFacilitiesPanel();
    } else if (_isFirstLoad) {
      bodyContent = Homepage(
        onFindBloodTap: () {
          setState(() {
            _currentIndex = 0; // FindBloodPage
            _isFirstLoad = false;
          });
        },
        onNearestFacilitiesTap: () {
          setState(() {
            _showNearestFacilities = true;
          });
        },
        onInformationPageTap: () {
          setState(() {
            _currentIndex = 2; // Information
            _isFirstLoad = false;
          });
        },
      );
    } else {
      bodyContent = widgetOptions.elementAt(_currentIndex);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFBEAEA),
        elevation: 0,
        centerTitle: true,
        // Changing Page Titles depending on the pages
        title: Text(
          _showNearestFacilities
              ? "Nearest Facilities"
              : _isFirstLoad
                  ? "Home"
                  : pageTitles[_currentIndex],
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFFD14E52),
            fontSize: 24,
          ),
          textAlign: TextAlign.center,
        ),
        //Back Button only if not on Home
        leading: (_isFirstLoad && !_showNearestFacilities)
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back), // <-- Add const here
                tooltip: "Home",
                onPressed: () {
                  setState(() {
                    if (_showNearestFacilities) {
                      _showNearestFacilities = false;
                      _isFirstLoad = true;
                    } else {
                      _isFirstLoad = true;
                    }
                  });
                },
              ),
      ),
      body: Center(
        child: bodyContent,
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFFD14E52),
        unselectedItemColor: const Color(0xFF434343),
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400, // Poppins Regular
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400, // Poppins Regular
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_outlined),
            activeIcon: Icon(Icons.pin_drop_sharp),
            label: "Find Blood",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outlined),
            activeIcon: Icon(Icons.bookmark_add_sharp),
            label: "Saved Places",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark_outlined),
            activeIcon: Icon(Icons.question_mark_sharp),
            label: "FAQs",
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTap, //Passing on Tap
      ),
    );
  }
}
