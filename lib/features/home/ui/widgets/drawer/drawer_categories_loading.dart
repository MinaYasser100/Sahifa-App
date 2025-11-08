import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class DrawerCategoriesLoading extends StatelessWidget {
  const DrawerCategoriesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 6, // Show 6 skeleton items
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: _buildSkeletonItem(isDarkMode),
          );
        },
      ),
    );
  }

  Widget _buildSkeletonItem(bool isDarkMode) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
            : ColorsTheme().primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon skeleton
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 16),
            // Title skeleton
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Badge skeleton
            Container(
              width: 30,
              height: 24,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
