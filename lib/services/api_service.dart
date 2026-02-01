import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

import '../models/asteroid_model.dart';
import '../models/feed_item.dart';
import '../models/news_model.dart';

class ApiService {
  Future<ApodModel> fetchApod({DateTime? date}) async {
    final String apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';
    String url = 'https://api.nasa.gov/planetary/apod?api_key=$apiKey';
    if (date != null) {
      String formattedDate =
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      url += '&date=$formattedDate';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ApodModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load APOD');
    }
  }

  Future<(List<FeedItem>, String?)> fetchSpaceNews({String? nextUrl}) async {
    final url =
        nextUrl ?? 'https://api.spaceflightnewsapi.net/v4/articles?limit=10';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      final String? next = data['next'];

      final items = results.map((json) {
        final news = NewsModel.fromJson(json);
        return FeedItem(type: FeedType.news, data: news);
      }).toList();

      return (items, next);
    } else {
      throw Exception('Failed to load space news');
    }
  }

  Future<List<FeedItem>> fetchAsteroids() async {
    final String apiKey = dotenv.env['NASA_API_KEY'] ?? 'DEMO_KEY';
    final DateTime now = DateTime.now();
    final String todayDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final String url =
        'https://api.nasa.gov/neo/rest/v1/feed?start_date=$todayDate&end_date=$todayDate&api_key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, dynamic> nearEarthObjects = data['near_earth_objects'];

      if (nearEarthObjects.containsKey(todayDate)) {
        final List<dynamic> asteroidsJson = nearEarthObjects[todayDate];
        return asteroidsJson.map((json) {
          final asteroid = AsteroidModel.fromJson(json);
          return FeedItem(type: FeedType.asteroid, data: asteroid);
        }).toList();
      }
      return [];
    } else {
      debugPrint('Failed to load asteroids: ${response.body}');
      return []; // Return empty list on failure to not break the feed
    }
  }
}
