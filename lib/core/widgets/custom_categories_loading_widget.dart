import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class CustomCategoriesLoadingWidget extends StatelessWidget {
  const CustomCategoriesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3, // Show 3 skeleton sections
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: _buildSkeletonSection(isDarkMode),
        );
      },
    );
  }

  Widget _buildSkeletonSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 150,
                height: 24,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),

        // Horizontal articles list skeleton
        SizedBox(
          height: 325,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildSkeletonCard(isDarkMode),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonCard(bool isDarkMode) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
            : ColorsTheme().primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                  : ColorsTheme().primaryLight.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge skeleton
                Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                // Title skeleton
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  width: 200,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                // Summary skeleton
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.15)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.15)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
