class NewsModel {
  final String title;
  final String imageUrl;
  final String summary;
  final String url;
  final String source;
  final DateTime publishedAt;

  NewsModel({
    required this.title,
    required this.imageUrl,
    required this.summary,
    required this.url,
    required this.source,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? 'No Title',
      imageUrl: json['image_url'] ?? '',
      summary: json['summary'] ?? 'No Summary',
      url: json['url'] ?? '',
      source: json['news_site'] ?? 'Unknown Source',
      publishedAt: DateTime.parse(json['published_at']),
    );
  }
}
