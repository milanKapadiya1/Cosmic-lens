import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlanetService {
  Future<Map<String, String>?> fetchMarsWeather() async {
    try {
      final url = Uri.parse(
          'https://mars.nasa.gov/rss/api/?feed=weather&category=msl&feedtype=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final sols = data['sols'] as List;

        if (sols.isNotEmpty) {
          // MSL feed usually has the latest sol at the beginning or end.
          // Let's check the structure usually provided.
          final latestSol = sols.first; // MSL feed often puts latest first

          final maxTemp = latestSol['max_temp'];
          final minTemp = latestSol['min_temp'];
          final dateStr = latestSol['terrestrial_date']; // "2026-01-30"

          if (dateStr != null) {
            // Format date
            final date = DateTime.parse(dateStr);
            final formattedDate = DateFormat('MMM d, yyyy').format(date);

            // Format Temp
            String tempStr = '$maxTemp° / $minTemp°';
            if (maxTemp == null || minTemp == null) {
              tempStr = 'Data Unavailable';
            }

            return {
              'temp': tempStr,
              'date': formattedDate,
            };
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching Mars weather: $e');
    }
    return null;
  }
}
