import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apod_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

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
}
