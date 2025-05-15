import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sandugo/HomePage.dart';
import 'package:sandugo/NearestFacilities.dart';
import 'package:sandugo/navbar.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:sandugo/splash_screen.dart';

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
      home: SplashScreen(), 
      debugShowCheckedModeBanner: false,
    );
  }
}
