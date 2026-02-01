import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/feed_provider.dart';
import '../models/asteroid_model.dart';
import '../widgets/asteroid_card.dart';

class AsteroidScreen extends StatefulWidget {
  const AsteroidScreen({super.key});

  @override
  State<AsteroidScreen> createState() => _AsteroidScreenState();
}

class _AsteroidScreenState extends State<AsteroidScreen> {
  @override
  void initState() {
    super.initState();
    // Load feed if empty
    Future.microtask(() {
      final provider = Provider.of<FeedProvider>(context, listen: false);
      if (provider.asteroidItems.isEmpty) {
        provider.loadFeed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asteroid Monitor',
            style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                const Color(0xFF010101),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<FeedProvider>(context, listen: false).loadFeed();
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Consumer<FeedProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.asteroidItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.asteroidItems.isEmpty) {
            return const Center(
              child: Text(
                'No potentially hazardous objects found.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.asteroidItems.length + 1, // +1 for header
            itemBuilder: (context, index) {
              if (index == 0) {
                // Header
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Near Earth Objects Today',
                        style: GoogleFonts.orbitron(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Track asteroids passing Earth today. Sizes compared to the Burj Khalifa (828m).',
                        style: GoogleFonts.orbitron(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }

              final item = provider.asteroidItems[index - 1]; // Adjust index
              return AsteroidCard(asteroid: item.data as AsteroidModel);
            },
          );
        },
      ),
    );
  }
}
