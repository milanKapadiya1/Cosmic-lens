import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/apod_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Fetch data when screen initializes
    Future.microtask(
        () => Provider.of<ApodProvider>(context, listen: false).getData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Cosmic Lens Lite',
            style: GoogleFonts.orbitron(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
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
                if (context.mounted) {
                  setState(() {
                    _currentDate = picked;
                  });
                  Provider.of<ApodProvider>(context, listen: false)
                      .getData(date: picked);
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0B3D91), // NASA Blue
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Consumer<ApodProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage.isNotEmpty) {
                return const Center(
                  child: Text(
                    'Data unavailable',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (provider.data != null) {
                final apod = provider.data!;
                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity! < 0) {
                      // Swipe Left - Previous Day
                      final tenDaysAgo =
                          DateTime.now().subtract(const Duration(days: 10));
                      if (_currentDate.isAfter(tenDaysAgo)) {
                        setState(() {
                          _currentDate =
                              _currentDate.subtract(const Duration(days: 1));
                        });
                        Provider.of<ApodProvider>(context, listen: false)
                            .getData(date: _currentDate);
                      }
                    } else if (details.primaryVelocity! > 0) {
                      // Swipe Right - Next Day
                      final today = DateTime.now();
                      // Compare dates ignoring time
                      final isToday = _currentDate.year == today.year &&
                          _currentDate.month == today.month &&
                          _currentDate.day == today.day;

                      if (!isToday && _currentDate.isBefore(today)) {
                        setState(() {
                          _currentDate =
                              _currentDate.add(const Duration(days: 1));
                        });
                        Provider.of<ApodProvider>(context, listen: false)
                            .getData(date: _currentDate);
                      }
                    }
                  },
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: RefreshIndicator(
                        color: Colors.white,
                        backgroundColor: const Color(0xFF0B3D91),
                        onRefresh: () async {
                          setState(() {
                            _currentDate = DateTime.now();
                          });
                          await Provider.of<ApodProvider>(context,
                                  listen: false)
                              .getData();
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          child: ListView(
                            key: ValueKey(_currentDate),
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
                                              // Handle error silently or show snackbar
                                              debugPrint(
                                                  'Could not launch $uri');
                                            }
                                          },
                                          child: Container(
                                            height: 200,
                                            width: double.infinity,
                                            color: Colors
                                                .black45, // Generic space background
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.play_circle_fill,
                                                    color: Colors.white,
                                                    size: 60),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Watch Video',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: apod.url,
                                          placeholder: (context, url) =>
                                              const SizedBox(
                                            height: 200,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error,
                                                  color: Colors.red),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                apod.date,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                apod.explanation,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return const Center(
                  child:
                      Text('No Data', style: TextStyle(color: Colors.white)));
            },
          ),
        ),
      ),
    );
  }
}
