import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_image_section.dart';
import 'package:sahifa/core/widgets/custom_trending/tablet_card_content_section.dart';

class TabletTrendingArticleCard extends StatelessWidget {
  const TabletTrendingArticleCard({
    super.key,
    required this.articleItem,
    required this.index,
  });

  final ArticleModel articleItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return FadeInUp(
      delay: Duration(milliseconds: index * 50),
      child: _CardContainer(
        isDarkMode: isDarkMode,
        articleItem: articleItem,
        index: index,
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  const _CardContainer({
    required this.isDarkMode,
    required this.articleItem,
    required this.index,
  });

  final bool isDarkMode;
  final ArticleModel articleItem;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? ColorsTheme().cardColor : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabletCardImageSection(
            imageUrl: articleItem.image ?? '',
            index: index,
          ),
          TabletCardContentSection(articleItem: articleItem),
        ],
      ),
    );
  }
}
