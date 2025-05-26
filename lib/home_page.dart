import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  final VoidCallback? onFindBloodTap;
  final VoidCallback? onNearestFacilitiesTap;
  final VoidCallback? onInformationPageTap;
  const Homepage(
      {super.key,
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
      backgroundColor: const Color(0xFFF9EDEC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            children: [
              _buildHomeButton(
                index: 0,
                color: const Color(0xFFD14E52),
                icon: Icons.opacity,
                text: 'FIND BLOOD',
                onTap: widget.onFindBloodTap ?? () {},
              ),
              const SizedBox(height: 16),
              _buildHomeButton(
                index: 1,
                color: const Color(0xFFFF7C80),
                icon: Icons.local_hospital,
                text: 'NEAREST FACILITIES',
                onTap: widget.onNearestFacilitiesTap ?? () {},
              ),
              const SizedBox(height: 16),
              _buildHomeButton(
                index: 2,
                color: const Color(0xFFFFB2B4),
                icon: Icons.help_outline,
                text: 'INFORMATION PAGE',
                onTap: widget.onInformationPageTap ?? () {},
              ),
            ],
          ),
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double buttonHeight = screenHeight * 0.25;

    // Responsive icon and text size based on button height
    final double iconSize = buttonHeight * 0.9; // 50% of button height
    final double textSize = buttonHeight * 0.18; // 18% of button height

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredIndex = index),
      onExit: (_) => setState(() => hoveredIndex = null),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: buttonHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isHovered ? darken(color, 0.08) : color,
            borderRadius: BorderRadius.circular(50),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: color.withAlpha((255 * 0.4).toInt()),
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
                size: iconSize,
                color: _getIconColor(index),
              ),
              // Center the text using a Column
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: textSize,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFFFF696E); // FIND BLOOD
      case 1:
        return const Color(0xFFFF6368); // NEAREST FACILITIES
      case 2:
        return const Color(0xFFFF9598); // INFORMATION PAGE
      default:
        return Colors.white.withAlpha((255 * 0.2).toInt());
    }
  }
}

Color darken(Color color, [double amount = .1]) {
  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
  return hslDark.toColor();
}
