import 'package:flutter/material.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/features/home/ui/widgets/news_item_metadata.dart';

class NewsItemContent extends StatelessWidget {
  const NewsItemContent({super.key, required this.newsItem});

  final NewsItemModel newsItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Text(
            newsItem.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // الوصف
          Text(
            newsItem.description,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),

          // خط فاصل
          Divider(color: Colors.grey[300], height: 1),
          const SizedBox(height: 8),

          // التاريخ و عدد المشاهدين
          NewsItemMetadata(
            date: newsItem.date,
            viewerCount: newsItem.viewerCount,
          ),
        ],
      ),
    );
  }
}
