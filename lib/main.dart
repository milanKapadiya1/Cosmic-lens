import 'package:cosmic_lens_lite/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/apod_provider.dart';
import 'providers/feed_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApodProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
      ],
      child: MaterialApp(
        title: 'Cosmic Lens Lite',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF010101), // Pitch Black
          cardColor: const Color(0xFF272727), // Dark Grey
          primaryColor: const Color(0xFFEB8530), // Mars Orange
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFEB8530), // Mars Orange
            secondary: Color(0xFFEB8530),
            surface: Color(0xFF272727), // Dark Grey
            onSurface: Colors.white,
            error: Color(0xFFE04724), // Red-Orange
          ),
          textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme),
        ),
        debugShowCheckedModeBanner: false,
        home: const MainScreen(),
      ),
    );
  }
}
