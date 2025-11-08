import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_category_item.dart';

class DrawerCategoriesList extends StatelessWidget {
  const DrawerCategoriesList({super.key, required this.categories});

  final List<ParentCategory> categories;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // الـ categories جايه جاهزة من الـ Cubit (filtered & sorted)
    if (categories.isEmpty) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  FontAwesomeIcons.inbox,
                  size: 48,
                  color: isDarkMode
                      ? ColorsTheme().secondaryLight.withValues(alpha: 0.5)
                      : ColorsTheme().primaryColor.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'لا توجد فئات متاحة',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode
                        ? ColorsTheme().secondaryLight
                        : ColorsTheme().primaryDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }
    final filterCategories = categories
        .where(
          (category) =>
              category.subcategories != null &&
              category.subcategories!.isNotEmpty,
        )
        .toList();

    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: filterCategories.length,
        itemBuilder: (context, index) {
          return DrawerCategoryItem(parentCategory: filterCategories[index]);
        },
      ),
    );
  }
}
