import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/parent_category/subcategory.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

class DrawerSubcategoryItem extends StatelessWidget {
  const DrawerSubcategoryItem({super.key, required this.subcategory});

  final SubcategoryInfoModel subcategory;

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
          subcategory.name ?? 'No Name'.tr(),
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

          // Navigate to category view with subcategory data
          context.push(Routes.drawerSubCategoryContent, extra: subcategory);
        },
      ),
    );
  }
}
