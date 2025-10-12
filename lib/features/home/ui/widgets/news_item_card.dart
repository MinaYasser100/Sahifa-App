import 'package:flutter/material.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/features/home/ui/widgets/news_item_content.dart';
import 'package:sahifa/features/home/ui/widgets/news_item_image.dart';

class NewsItemCard extends StatelessWidget {
  const NewsItemCard({super.key, required this.newsItem});

  final NewsItemModel newsItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Section
          NewsItemImage(imageUrl: newsItem.imageUrl),

          // Content Section
          NewsItemContent(newsItem: newsItem),
        ],
      ),
    );
  }
}
