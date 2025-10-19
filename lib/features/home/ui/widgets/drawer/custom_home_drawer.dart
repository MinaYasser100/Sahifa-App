import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/categories_data.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_category_tile.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_header.dart';

class CustomHomeDrawer extends StatelessWidget {
  const CustomHomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final categories = CategoriesData.getCategories();

    return Drawer(
      backgroundColor: isDarkMode
          ? ColorsTheme().backgroundColor
          : ColorsTheme().whiteColor,
      child: Column(
        children: [
          // Drawer Header
          const CustomDrawerHeader(),

          // Categories List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return DrawerCategoryTile(
                  categoryWithSubcategories: categories[index],
                );
              },
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
