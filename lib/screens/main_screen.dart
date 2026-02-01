import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'apod_screen.dart';
import '../widgets/glass_bottom_bar.dart';

import 'package:cosmic_lens_lite/screens/feed_screen.dart'; // Import FeedScreen

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(), // Index 0: Planet Explorer
    const FeedScreen(), // Index 1: News Feed (Social)
    const ApodScreen(), // Index 2: APOD (Gallery)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows body to extend behind the floating bar
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: GlassBottomBar(
        selectedIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
