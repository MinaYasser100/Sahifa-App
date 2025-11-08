import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/search/ui/widgets/category_card_content.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    super.key,
    required this.categoryName,
    required this.onTap,
    this.isLarge = false,
  });

  final String categoryName;
  final VoidCallback onTap;
  final bool isLarge;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isDarkMode ? ColorsTheme().cardColor : ColorsTheme().whiteColor,
        child: FadeInLeft(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Decorative background pattern
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? ColorsTheme().grayColor.withValues(alpha: 0.5)
                          : ColorsTheme().primaryColor.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDarkMode
                          ? ColorsTheme().grayColor.withValues(alpha: 0.12)
                          : ColorsTheme().primaryLight.withValues(alpha: 0.06),
                    ),
                  ),
                ),

                CategoryCardContent(
                  categoryName: categoryName,
                  icon: _getCategoryIcon(categoryName),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'al-thawra archive':
        return Icons.archive_outlined;
      case 'obituaries':
        return Icons.person_outline;
      case 'photo gallery':
        return Icons.photo_library_outlined;
      case 'books & opinions':
        return Icons.menu_book_outlined;
      case 'economy':
        return Icons.attach_money;
      case 'security & courts':
        return Icons.gavel_outlined;
      case 'sports':
        return Icons.sports_soccer_outlined;
      case 'local news':
        return Icons.location_city_outlined;
      default:
        return Icons.article_outlined;
    }
  }
}
