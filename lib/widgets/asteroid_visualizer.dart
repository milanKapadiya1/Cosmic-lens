import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AsteroidVisualizer extends StatelessWidget {
  final double diameterInMeters;
  final bool isHazardous;

  const AsteroidVisualizer({
    super.key,
    required this.diameterInMeters,
    required this.isHazardous,
  });

  @override
  Widget build(BuildContext context) {
    // Math for size scaling
    const double buildingHeightMeters = 828;
    const double widgetHeight = 160;

    // Calculate proportional height
    double visualSize =
        (diameterInMeters / buildingHeightMeters) * widgetHeight;
    debugPrint(
        'Asteroid: ${diameterInMeters}m -> Calculated Size: ${visualSize}px');

    // Use Mars Orange for safe state instead of Blue
    final primaryColor =
        isHazardous ? const Color(0xFFE04724) : const Color(0xFFEB8530);

    return Container(
      height: 180, // Fixed height for container
      width: double.infinity,
      color: Colors.transparent, // Keep transparent
      child: Stack(
        alignment:
            Alignment.bottomCenter, // Ensure items are anchored to bottom
        children: [
          // Burj Khalifa (Reference)
          Positioned(
            right: 20,
            bottom: 0, // Align exactly to bottom
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/images/burj_khalifa.png',
                  height: widgetHeight,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    debugPrint('Error loading Burj: $error');
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
                Text(
                  'Burj Khalifa (828m)',
                  style: GoogleFonts.orbitron(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          // Asteroid (Dynamic Size Animation)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                width: visualSize,
                height: visualSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.6),
                      blurRadius: 20,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(visualSize / 2),
                  child: Transform.scale(
                    scale: 3.0, // Zoom to crop transparency
                    child: isHazardous
                        ? ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                Colors.red.withOpacity(0.3), BlendMode.srcATop),
                            child: Lottie.asset(
                              'assets/animations/asteroid.json',
                              fit: BoxFit.fill, // Force fill
                              onLoaded: (composition) {
                                debugPrint(
                                    'Lottie Animation Loaded: ${composition.duration}');
                              },
                            ),
                          )
                        : ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                const Color(0xFFEB8530).withOpacity(0.2),
                                BlendMode.srcATop),
                            child: Lottie.asset(
                              'assets/animations/asteroid.json',
                              fit: BoxFit.fill, // Force fill
                              onLoaded: (composition) {
                                debugPrint(
                                    'Lottie Animation Loaded: ${composition.duration}');
                              },
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
