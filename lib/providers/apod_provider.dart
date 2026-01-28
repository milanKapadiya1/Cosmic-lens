import 'package:flutter/material.dart';
import '../models/apod_model.dart';
import '../services/api_service.dart';

class ApodProvider extends ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  ApodModel? data;
  final Map<String, ApodModel> _cache = {};

  Future<void> getData({DateTime? date}) async {
    final DateTime targetDate = date ?? DateTime.now();
    final String key =
        "${targetDate.year}-${targetDate.month.toString().padLeft(2, '0')}-${targetDate.day.toString().padLeft(2, '0')}";

    if (_cache.containsKey(key)) {
      data = _cache[key];
      errorMessage = '';
      isLoading = false;
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      final apiService = ApiService();
      final result = await apiService.fetchApod(date: date);
      data = result;
      _cache[key] = result;
      errorMessage = '';
    } catch (e) {
      debugPrint(e.toString()); // Log error to console
      errorMessage = 'Error'; // Set generic error signal
      data = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
