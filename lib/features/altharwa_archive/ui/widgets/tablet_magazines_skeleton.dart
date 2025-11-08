import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class TabletMagazinesSkeleton extends StatelessWidget {
  const TabletMagazinesSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.6,
        ),
        itemCount: 12,
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
                // Magazine cover skeleton
                Expanded(
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
                        Icons.picture_as_pdf,
                        size: 64,
                        color: isDarkMode
                            ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                            : ColorsTheme().primaryLight.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ),
                
                // Info skeleton
                Padding(
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
                        width: 100,
                        height: 14,
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
              ],
            ),
          );
        },
      ),
    );
  }
}
