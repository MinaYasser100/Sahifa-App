import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date_from_utc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletCardMetadata extends StatelessWidget {
  const TabletCardMetadata({
    super.key,
    required this.articleItem,
  });

  final ArticleModel articleItem;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _DateInfo(
          publishedAt: articleItem.publishedAt,
          isDarkMode: isDarkMode,
        ),
        if (articleItem.viewsCount != null)
          _ViewsInfo(
            viewsCount: articleItem.viewsCount!,
            isDarkMode: isDarkMode,
          ),
      ],
    );
  }
}

class _DateInfo extends StatelessWidget {
  const _DateInfo({
    required this.publishedAt,
    required this.isDarkMode,
  });

  final String? publishedAt;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: isDarkMode
              ? ColorsTheme().grayColor
              : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            formatDateFromUTC(publishedAt),
            style: AppTextStyles.styleRegular12sp(context).copyWith(
              color: isDarkMode
                  ? ColorsTheme().grayColor
                  : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ViewsInfo extends StatelessWidget {
  const _ViewsInfo({
    required this.viewsCount,
    required this.isDarkMode,
  });

  final int viewsCount;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 8),
        Icon(
          Icons.visibility_outlined,
          size: 14,
          color: isDarkMode
              ? ColorsTheme().grayColor
              : Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          '$viewsCount',
          style: AppTextStyles.styleRegular12sp(context).copyWith(
            color: isDarkMode
                ? ColorsTheme().grayColor
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
