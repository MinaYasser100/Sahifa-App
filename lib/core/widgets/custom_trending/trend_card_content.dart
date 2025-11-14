import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date_from_utc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class TrendCardContent extends StatelessWidget {
  const TrendCardContent({super.key, required this.articleItem});

  final ArticleModel articleItem;

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
                articleItem.title ?? "No Name".tr(),
                style: AppTextStyles.styleBold16sp(context).copyWith(
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
                    size: 12,
                    color: isDarkMode
                        ? ColorsTheme().grayColor.withValues(alpha: 0.6)
                        : ColorsTheme().grayColor.withValues(alpha: 0.8),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatDateFromUTC(articleItem.createdAt ?? ''),
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
