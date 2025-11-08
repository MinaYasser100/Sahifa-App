import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletOtherCategoriesSkeleton extends StatelessWidget {
  const TabletOtherCategoriesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
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
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                          : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.article,
                        size: 48,
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                            : ColorsTheme().primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                
                // Content skeleton
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        const SizedBox(height: 8),
                        Container(
                          width: 150,
                          height: 14,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                                : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 100,
                          height: 12,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                                : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
