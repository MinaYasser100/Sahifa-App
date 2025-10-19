import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/models/category_with_subcategories.dart';

class DrawerSubcategoryTile extends StatelessWidget {
  const DrawerSubcategoryTile({super.key, required this.subcategory});

  final SubcategoryModel subcategory;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryLight.withValues(alpha: 0.5)
            : ColorsTheme().softBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 56, right: 16),
        dense: true,
        leading: Icon(
          Icons.circle,
          size: 8,
          color: isDarkMode
              ? ColorsTheme().secondaryLight
              : ColorsTheme().primaryColor,
        ),
        title: Text(
          subcategory.name,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDarkMode
                ? ColorsTheme().whiteColor.withValues(alpha: 0.95)
                : Colors.grey[800],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 12,
          color: isDarkMode
              ? ColorsTheme().softBlue
              : ColorsTheme().primaryLight,
        ),
        onTap: () {
          // Close drawer
          Navigator.pop(context);

          // Navigate to category view
          context.push(Routes.drawerSubCategoryContent, extra: subcategory);
        },
      ),
    );
  }
}
