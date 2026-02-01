import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/asteroid_model.dart';
import '../widgets/asteroid_visualizer.dart';

class AsteroidCard extends StatelessWidget {
  final AsteroidModel asteroid;

  const AsteroidCard({super.key, required this.asteroid});

  @override
  Widget build(BuildContext context) {
    final isHazardous = asteroid.isHazardous;
    final primaryColor =
        isHazardous ? const Color(0xFFE04724) : const Color(0xFFEB8530);

    // Parsing velocity safely
    double velocityVal = 0.0;
    try {
      velocityVal = double.parse(asteroid.velocity);
    } catch (e) {
      debugPrint('Error parsing velocity: $e');
    }

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF272727), // Solid Dark Grey
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header: Name and Badge
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    asteroid.name.replaceFirst('(', '').replaceFirst(')', ''),
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isHazardous ? 'HAZARDOUS' : 'SAFE',
                    style: GoogleFonts.outfit(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Visualizer
          AsteroidVisualizer(
            diameterInMeters: asteroid.diameterMax,
            isHazardous: isHazardous,
          ),

          // Footer: Jupiter Style Stats
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildStat('DIAMETER', '${asteroid.diameterMax.toInt()}m'),
                _buildDivider(),
                _buildStat('SPEED', '${velocityVal.toInt()} km/h'),
                _buildDivider(),
                _buildStat('APPROACH', asteroid.formattedTime),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }
}
