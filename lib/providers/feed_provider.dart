import 'package:flutter/material.dart';
import '../models/feed_item.dart';
import '../services/api_service.dart';

class FeedProvider with ChangeNotifier {
  List<FeedItem> _newsItems = [];
  List<FeedItem> _asteroidItems = [];
  bool _isLoading = false;
  String? _nextUrl;

  List<FeedItem> get newsItems => _newsItems;
  List<FeedItem> get asteroidItems => _asteroidItems;
  bool get isLoading => _isLoading;
  bool get hasMore => _nextUrl != null;

  final ApiService _apiService = ApiService();

  Future<void> loadFeed() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.fetchSpaceNews(),
        _apiService.fetchAsteroids(),
      ]);

      final (newsItems, next) = results[0] as (List<FeedItem>, String?);
      final asteroids = results[1] as List<FeedItem>;

      _newsItems = newsItems;
      _asteroidItems = asteroids;
      _nextUrl = next;
    } catch (e) {
      debugPrint("Error loading feed: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreNews() async {
    if (_isLoading || _nextUrl == null) return;

    _isLoading =
        true; // Or use a separate loading state for pagination if desired
    notifyListeners();

    try {
      final (items, next) = await _apiService.fetchSpaceNews(nextUrl: _nextUrl);
      _newsItems.addAll(items);
      _nextUrl = next;
    } catch (e) {
      debugPrint("Error loading more news: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
