import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_subcategory_item.dart';

class DrawerCategoryItem extends StatelessWidget {
  const DrawerCategoryItem({super.key, required this.parentCategory});

  final ParentCategory parentCategory;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Filter active subcategories
    final activeSubcategories = parentCategory.subcategories ?? [];

    // Sort by order
    activeSubcategories.sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

    // Use API count if available, otherwise use actual list length
    final subcategoriesCount =
        parentCategory.subCategoriesCount ?? activeSubcategories.length;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        leading: Icon(
          FontAwesomeIcons.layerGroup,
          color: isDarkMode
              ? ColorsTheme().secondaryLight
              : ColorsTheme().primaryColor,
          size: 22,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                parentCategory.name ?? 'No Name'.tr(),
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
            if (subcategoriesCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                      : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$subcategoriesCount',
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
        children: activeSubcategories.map((subcategory) {
          return DrawerSubcategoryItem(subcategory: subcategory);
        }).toList(),
      ),
    );
  }
}
