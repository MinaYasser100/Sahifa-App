import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/features/home/ui/widgets/artical_item_metadata.dart';

class ArticalItemContent extends StatelessWidget {
  const ArticalItemContent({super.key, required this.articalItem});

  final ArticalItemModel articalItem;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Row(
              children: [
                Expanded(
                  child: Text(
                    articalItem.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorsTheme().primaryLight,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    FontAwesomeIcons.share,
                    color: ColorsTheme().primaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // الوصف
            Text(
              articalItem.description,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Spacer علشان يدفع الباقي لتحت
            const Spacer(),

            // خط فاصل
            Divider(
              color: ColorsTheme().grayColor.withValues(alpha: 0.2),
              height: 1,
            ),
            const SizedBox(height: 8),

            // التاريخ و عدد المشاهدين
            ArticalItemMetadata(
              date: articalItem.date,
              viewerCount: articalItem.viewerCount,
            ),
          ],
        ),
      ),
    );
  }
}
