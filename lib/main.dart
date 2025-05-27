import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sandugo/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialize Firebase
  Future<FirebaseApp> _initializeFirebase() async {
    return await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'sanDUGO',
      debugShowCheckedModeBanner: false, // <-- Add this line
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: 'Poppins',
            ),
      ),
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                  child: Text('Firebase init failed: ${snapshot.error}')),
            );
          } else {
            return const SplashScreen(); // continue to your app
          }
        },
      ),
    );
  }
}