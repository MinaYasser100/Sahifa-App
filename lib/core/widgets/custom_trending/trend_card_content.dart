import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';

class TrendCardContent extends StatelessWidget {
  const TrendCardContent({super.key, required this.articleItem});

  final ArticalItemModel articleItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              articleItem.title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: ColorsTheme().primaryLight,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),

            // Date
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  formatDate(articleItem.date),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
