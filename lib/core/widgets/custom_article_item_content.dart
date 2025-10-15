import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/news_item_model.dart';
import 'package:sahifa/core/widgets/custom_article_item_metadata.dart';

class CustomArticleItemContent extends StatelessWidget {
  const CustomArticleItemContent({super.key, required this.articleItem});

  final ArticalItemModel articleItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            FadeInLeft(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      articleItem.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode
                            ? ColorsTheme().secondaryLight
                            : ColorsTheme().primaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Handle share action
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Share functionality will be implemented',
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    child: FadeInDown(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Icon(
                          FontAwesomeIcons.share,
                          color: isDarkMode
                              ? ColorsTheme().secondaryLight
                              : ColorsTheme().primaryLight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // الوصف
            FadeInLeft(
              child: Text(
                articleItem.description,
                style: TextStyle(
                  fontSize: 13,
                  color: isDarkMode
                      ? ColorsTheme().whiteColor.withValues(alpha: 0.7)
                      : Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Spacer علشان يدفع الباقي لتحت
            const Spacer(),

            // خط فاصل
            FadeInLeft(
              child: Divider(
                color: isDarkMode
                    ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
                    : ColorsTheme().grayColor.withValues(alpha: 0.2),
                height: 1,
              ),
            ),
            const SizedBox(height: 8),

            // التاريخ و عدد المشاهدين
            FadeInUp(
              child: CustomArticleItemMetadata(
                date: articleItem.date,
                viewerCount: articleItem.viewerCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
