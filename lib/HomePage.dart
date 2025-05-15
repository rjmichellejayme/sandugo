import 'package:flutter/material.dart';
import 'package:sandugo/navbar.dart';
import 'FindBloodPage.dart';

class Homepage extends StatefulWidget {
  final VoidCallback? onFindBloodTap;
  final VoidCallback? onNearestFacilitiesTap;
  final VoidCallback? onInformationPageTap;
  const Homepage({super.key, 
                this.onFindBloodTap, 
                this.onNearestFacilitiesTap, 
                this.onInformationPageTap});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBEAEA),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0, 
          vertical: 16),
        child: Column(
          children: [
            _buildHomeButton(
              color: const Color(0xFFFFCDD2),
              icon: Icons.opacity,
              text: 'FIND BLOOD',
              onTap: widget.onFindBloodTap ?? (){},
            ),
            const SizedBox(height: 16),
            _buildHomeButton(
              color: const Color(0xFFF48FB1),
              icon: Icons.local_hospital,
              text: 'NEAREST FACILITIES' ,
              onTap: widget.onNearestFacilitiesTap ?? () {
                // Navigate to Nearest Facilities Page
              },
            ),
            const SizedBox(height: 16),
            _buildHomeButton(
              color: const Color(0xFFE57373),
              icon: Icons.help_outline,
              text: 'INFORMATION PAGE',
              onTap: widget.onInformationPageTap ?? () {
                // Navigate to Information Page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton({
    required Color color,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              size: 100,
              color: Colors.white.withOpacity(0.2),
            ),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
