import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/banner_model.dart';

class CarouselDotsIndicator extends StatelessWidget {
  const CarouselDotsIndicator({
    super.key,
    required this.banners,
    required this.currentIndex,
    required this.onDotTap,
  });

  final List<BannerModel> banners;
  final int currentIndex;
  final Function(int) onDotTap;

  @override
  Widget build(BuildContext context) {
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
                  ? ColorsTheme().primaryColor
                  : ColorsTheme().grayColor.withValues(alpha: 0.4),
            ),
          ),
        );
      }).toList(),
    );
  }
}
