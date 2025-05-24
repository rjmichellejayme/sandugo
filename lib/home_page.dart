import 'package:flutter/material.dart';

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
  int? hoveredIndex;

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
              index: 0,
              color: const Color(0xFFE57373),
              icon: Icons.opacity,
              text: 'FIND BLOOD',
              onTap: widget.onFindBloodTap ?? (){},
            ),
            const SizedBox(height: 16),
            _buildHomeButton(
              index: 1,
              color: const Color(0xFFF48FB1),
              icon: Icons.local_hospital,
              text: 'NEAREST FACILITIES' ,
              onTap: widget.onNearestFacilitiesTap ?? () {
                // Navigate to Nearest Facilities Page
              },
            ),
            const SizedBox(height: 16),
            _buildHomeButton(
              index: 2,
              color: const Color(0xFFFFCDD2),
              icon: Icons.help_outline,
              text: 'INFORMATION PAGE',
              onTap: widget.onInformationPageTap ?? () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeButton({
    required int index,
    required Color color,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    final bool isHovered = hoveredIndex == index;
    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIndex = index),
      onExit: (_) => setState(() => hoveredIndex = null),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isHovered ? darken(color, 0.08) : color,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: color.withAlpha((255 * 0.4).toInt()), // updated
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : [],
            border: isHovered
                ? Border.all(color: Colors.red.shade900, width: 2)
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 100,
                color: Colors.white.withAlpha((255 * 0.2).toInt()), // updated
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
      ),
    );
  }
}

Color darken(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
