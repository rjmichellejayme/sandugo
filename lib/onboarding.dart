import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool isLoading = false;
  Future<String?> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id;
    }
    return null;
  }

  Future<void> storeDeviceIdToFirestore() async {
  final prefs = await SharedPreferences.getInstance();
  final alreadyStored = prefs.getBool('device_id_stored') ?? false;

  if (alreadyStored) {
    print("Device ID already stored — skipping write.");
    return;
  }

  final userCredential = await FirebaseAuth.instance.signInAnonymously();
  final uid = userCredential.user?.uid;
  final deviceId = await getDeviceId();

  if (uid != null && deviceId != null) {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'device_id': deviceId,
        'created_at': FieldValue.serverTimestamp(),
      });

      await prefs.setBool('device_id_stored', true); // Set the flag
      print("Device ID stored for UID: $uid");
    } catch (e) {
      print("Firestore write error: $e");
    }
  } else {
    print("UID or device ID is null");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9EDEC),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Stack(
                children: [
                  Image.asset(
                    'assets/onboarding.png',
                    height: 260,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    height: 260,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(249, 237, 236, 0),
                          Color.fromRGBO(249, 237, 236, 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'SanDUGO',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 60,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'SanDUGO connects donors, patients, and blood banks to save lives efficiently and effortlessly.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF7A2323),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() => isLoading = true);
                          await storeDeviceIdToFirestore();
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const BottomNavBar()),
                            );
                          }
                          setState(() => isLoading = false);
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Get Started',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

