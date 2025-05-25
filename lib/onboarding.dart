import 'package:flutter/material.dart';
import 'navbar.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

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
                        const Color(0xFF7A2323), // Fixed: Added const
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BottomNavBar()),
                    );
                  },
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: 'Poppins', // Set font to Poppins
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
