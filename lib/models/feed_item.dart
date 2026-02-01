enum FeedType { news, asteroid }

class FeedItem {
  final FeedType type;
  final dynamic data;

  FeedItem({required this.type, required this.data});
}
