import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

class TrendCardContent extends StatelessWidget {
  const TrendCardContent({super.key, required this.articleItem});

  final ArticleItemModel articleItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: FadeInLeft(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                articleItem.title,
                style: AppTextStyles.styleBold20sp(context).copyWith(
                  color: isDarkMode
                      ? ColorsTheme().secondaryColor
                      : ColorsTheme().primaryColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Date
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDarkMode
                        ? ColorsTheme().grayColor.withValues(alpha: 0.6)
                        : ColorsTheme().grayColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatDate(articleItem.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode
                          ? ColorsTheme().grayColor.withValues(alpha: 0.6)
                          : ColorsTheme().grayColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
