import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/category_with_subcategories.dart';
import 'package:sahifa/features/home/ui/widgets/drawer_subcategory_tile.dart';

class DrawerCategoryTile extends StatelessWidget {
  const DrawerCategoryTile({
    super.key,
    required this.categoryWithSubcategories,
  });

  final CategoryWithSubcategories categoryWithSubcategories;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
                : ColorsTheme().primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getIconData(categoryWithSubcategories.icon),
            color: isDarkMode
                ? ColorsTheme().secondaryLight
                : ColorsTheme().primaryColor,
            size: 22,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                categoryWithSubcategories.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode
                      ? ColorsTheme().whiteColor
                      : ColorsTheme().primaryDark,
                ),
              ),
            ),
            // Badge with count
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${categoryWithSubcategories.subcategories.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode
                      ? ColorsTheme().secondaryLight
                      : ColorsTheme().primaryColor,
                ),
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.keyboard_arrow_down,
          color: isDarkMode
              ? ColorsTheme().secondaryLight
              : ColorsTheme().primaryColor,
        ),
        iconColor: isDarkMode
            ? ColorsTheme().secondaryLight
            : ColorsTheme().primaryColor,
        collapsedIconColor: isDarkMode
            ? ColorsTheme().secondaryLight
            : ColorsTheme().primaryColor,
        children: categoryWithSubcategories.subcategories.map((subcategory) {
          return DrawerSubcategoryTile(subcategory: subcategory);
        }).toList(),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'newspaper':
        return Icons.newspaper;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'attach_money':
        return Icons.attach_money;
      case 'computer':
        return Icons.computer;
      case 'movie':
        return Icons.movie;
      case 'favorite':
        return Icons.favorite;
      case 'menu_book':
        return Icons.menu_book;
      case 'security':
        return Icons.security;
      default:
        return Icons.category;
    }
  }
}
