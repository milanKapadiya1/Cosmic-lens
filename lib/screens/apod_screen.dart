import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/apod_provider.dart';

class ApodScreen extends StatefulWidget {
  const ApodScreen({super.key});

  @override
  State<ApodScreen> createState() => _ApodScreenState();
}

class _ApodScreenState extends State<ApodScreen> {
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch data if not already available in cache logic which provider handles
    // Actually, provider.getData() handles caching, but let's check if we need to load
    Future.microtask(
        () => Provider.of<ApodProvider>(context, listen: false).getData());
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(1995, 6, 16),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0B3D91),
              onPrimary: Colors.white,
              surface: Colors.black,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _currentDate = picked;
      });
      if (mounted) {
        Provider.of<ApodProvider>(context, listen: false).getData(date: picked);
      }
    }
  }

  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity == null) return;

    if (details.primaryVelocity! > 0) {
      // Swipe Right -> Previous Day
      setState(() {
        _currentDate = _currentDate.subtract(const Duration(days: 1));
      });
      Provider.of<ApodProvider>(context, listen: false)
          .getData(date: _currentDate);
    } else if (details.primaryVelocity! < 0) {
      // Swipe Left -> Next Day
      final today = DateTime.now();
      final isToday = _currentDate.year == today.year &&
          _currentDate.month == today.month &&
          _currentDate.day == today.day;

      if (!isToday && _currentDate.isBefore(today)) {
        setState(() {
          _currentDate = _currentDate.add(const Duration(days: 1));
        });
        Provider.of<ApodProvider>(context, listen: false)
            .getData(date: _currentDate);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Orion APOD',
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
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: _selectDate,
          ),
        ],
      ),
      backgroundColor: const Color(0xFF010101), // Pitch Black
      body: SafeArea(
        child: Consumer<ApodProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage.isNotEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Error loading APOD',
                        style: TextStyle(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () => provider.getData(date: _currentDate),
                      child: const Text('Retry'),
                    )
                  ],
                ),
              );
            }

            if (provider.data != null) {
              final apod = provider.data!;
              return GestureDetector(
                onHorizontalDragEnd: _handleSwipe,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Text(
                      apod.title,
                      style: GoogleFonts.orbitron(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 10,
                      shadowColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: apod.mediaType == 'video'
                            ? GestureDetector(
                                onTap: () async {
                                  final Uri uri = Uri.parse(apod.url);
                                  if (!await launchUrl(uri)) {
                                    debugPrint('Could not launch $uri');
                                  }
                                },
                                child: Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.black45,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.play_circle_fill,
                                          color: Colors.white, size: 60),
                                      SizedBox(height: 8),
                                      Text('Watch Video',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: apod.url,
                                placeholder: (context, url) => const SizedBox(
                                  height: 200,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error, color: Colors.red),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      apod.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      apod.explanation,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return const Center(
                child: Text('No Data', style: TextStyle(color: Colors.white)));
          },
        ),
      ),
    );
  }
}
