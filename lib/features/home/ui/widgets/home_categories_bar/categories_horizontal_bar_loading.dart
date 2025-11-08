import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CategoriesHorizontalBarLoading extends StatelessWidget {
  const CategoriesHorizontalBarLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryDark
            : ColorsTheme().primaryColor,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: 6, // عدد العناصر الوهمية
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: 100,
            decoration: BoxDecoration(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        },
      ),
    );
  }
}
