import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/feed_provider.dart';
import '../models/feed_item.dart';
import '../models/news_model.dart';
import '../widgets/news_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  void initState() {
    super.initState();
    // Load feed if empty
    Future.microtask(() {
      final provider = Provider.of<FeedProvider>(context, listen: false);
      if (provider.newsItems.isEmpty) {
        provider.loadFeed();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orion Feed',
            style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0)),
        backgroundColor: Colors.transparent, // Transparent to show gradient
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor, // Mars Orange
                const Color(0xFF010101), // Pitch Black (Fade to bg)
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<FeedProvider>(context, listen: false).loadFeed();
            },
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Consumer<FeedProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.newsItems.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.newsItems.isEmpty) {
            return const Center(
              child: Text(
                'No news available',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: provider.newsItems.length + 1,
            itemBuilder: (context, index) {
              if (index == provider.newsItems.length) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEB8530), Color(0xFFE04724)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEB8530).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: provider.isLoading
                            ? null
                            : () {
                                provider.loadMoreNews();
                              },
                        borderRadius: BorderRadius.circular(25),
                        child: Center(
                          child: provider.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'LOAD MORE NEWS',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              final item = provider.newsItems[index];

              if (item.type == FeedType.news) {
                return NewsCard(news: item.data as NewsModel);
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
