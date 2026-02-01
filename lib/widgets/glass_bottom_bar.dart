import 'dart:ui';
import 'package:flutter/material.dart';

class GlassBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const GlassBottomBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildIcon(0, Icons.home_filled, 'Home'), // Planet Explorer
                  _buildIcon(1, Icons.article, 'News'), // Feed
                  _buildIcon(2, Icons.photo_library, 'Gallery'), // APOD
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index, IconData icon, String label) {
    final isSelected = selectedIndex == index;
    final color = isSelected ? Colors.white : Colors.grey;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            // Optional: Tiny dot indicator or just color change
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFFEB8530), // Mars Orange
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
