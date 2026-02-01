import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/planet_model.dart';
import '../services/planet_service.dart';
import 'dart:ui'; // For ImageFilter

import '../widgets/orbiton_drawer.dart'; // Import Drawer

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>(); // Add Key
  int _selectedIndex = 0; // Default to Mars (index 0)
  Map<String, String>? marsWeatherData;

  @override
  void initState() {
    super.initState();
    loadLiveData();
  }

  Future<void> loadLiveData() async {
    final planet = Planet.planets[_selectedIndex];
    if (planet.name == 'Mars') {
      final data = await PlanetService().fetchMarsWeather();
      if (mounted && data != null) {
        setState(() {
          marsWeatherData = data;
        });
      }
    } else {
      if (marsWeatherData != null) {
        setState(() {
          marsWeatherData = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Current Planet Data
    final planet = Planet.planets[_selectedIndex];

    return Scaffold(
      key: _scaffoldKey, // Assign Key
      drawer: const OrbitonDrawer(), // Assign Drawer
      backgroundColor: const Color(0xFF010101), // Deep Space Black
      body: Stack(
        children: [
          // Layer 1: Background Image with Animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: SizedBox(
              key: ValueKey<String>(planet.assetPath),
              height: double.infinity,
              width: double.infinity,
              child: planet.assetPath.startsWith('http')
                  ? Image.network(
                      planet.assetPath,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      planet.assetPath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(color: Colors.black),
                    ),
            ),
          ),

          // Layer 2: Gradient Overlay (Transparent -> Black)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black26, // Transparent-ish at top
                  Colors.transparent,
                  Colors.black87,
                  Colors.black, // Solid black at bottom
                ],
                stops: [0.0, 0.2, 0.6, 1.0],
              ),
            ),
          ),

          // Layer 3: Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Orbiton Logo & Menu
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Orion',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.menu,
                            color: Colors.white, size: 28),
                        onPressed: () {
                          _scaffoldKey.currentState
                              ?.openDrawer(); // Open Drawer
                        },
                      ),
                    ],
                  ),
                ),

                // Planet Tabs
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 16),
                    itemCount: Planet.planets.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          loadLiveData();
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            Planet.planets[index].name,
                            style: GoogleFonts.outfit(
                              color: isSelected ? Colors.white : Colors.grey,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Spacer(), // Push content to bottom

                // Main Content
                // Main Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero Tagline
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        planet.tagline,
                        maxLines: 3,
                        style: GoogleFonts.outfit(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Stats Row
                    Builder(builder: (context) {
                      final isMars = planet.name == 'Mars';
                      final showLive = isMars && marsWeatherData != null;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          children: [
                            _buildHeroStat(
                              showLive ? 'Live Temp' : planet.stat1Label,
                              showLive
                                  ? marsWeatherData!['temp']!
                                  : planet.stat1Value,
                              labelColor: showLive
                                  ? const Color(0xFFEB8530)
                                  : Colors.grey,
                              subtext: showLive
                                  ? 'Latest: ${marsWeatherData!['date']}'
                                  : null,
                            ),
                            Container(
                              height: 40,
                              width: 1,
                              color: Colors.white24,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                            ),
                            _buildHeroStat(
                                planet.stat2Label, planet.stat2Value),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 30),

                    // Bottom Glass Cards
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: planet.details.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final detail = planet.details[index];
                          return _buildGlassCard(detail);
                        },
                      ),
                    ),
                    const SizedBox(height: 80), // Space for Bottom Bar
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroStat(String label, String value,
      {Color labelColor = Colors.grey, String? subtext}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: labelColor,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (subtext != null) ...[
          const SizedBox(height: 4),
          Text(
            subtext,
            style: GoogleFonts.outfit(
              color: Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGlassCard(Map<String, String> detail) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 130, // Fixed width for cards
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.public,
                      color: Colors.white70, size: 20), // Generic icon
                  // Determine icon based on title if possible
                  // or just simple layout
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail['value']!,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    detail['title']!,
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontSize: 12,
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
}
