import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

class CarouselDotsIndicator extends StatelessWidget {
  const CarouselDotsIndicator({
    super.key,
    required this.banners,
    required this.currentIndex,
    required this.onDotTap,
  });

  final List<ArticleItemModel> banners;
  final int currentIndex;
  final Function(int) onDotTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: banners.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => onDotTap(entry.key),
          child: Container(
            width: currentIndex == entry.key ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: currentIndex == entry.key
                  ? isDarkMode
                        ? ColorsTheme().primaryLight
                        : ColorsTheme().primaryColor
                  : isDarkMode
                  ? ColorsTheme().whiteColor
                  : ColorsTheme().grayColor.withValues(alpha: 0.4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
