import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/home/data/categories_data.dart';
import 'package:sahifa/features/home/data/models/category_with_subcategories.dart';

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
          _buildDrawerHeader(context, isDarkMode),

          // Categories List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryTile(
                  context,
                  categories[index],
                  isDarkMode,
                );
              },
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context, bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        bottom: 20,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [ColorsTheme().primaryDark, ColorsTheme().primaryColor]
              : [ColorsTheme().primaryColor, ColorsTheme().primaryLight],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.newspaper,
              size: 40,
              color: ColorsTheme().whiteColor,
            ),
          ),
          const SizedBox(height: 16),

          // App Name
          Text(
            'Al Thawra',
            style: AppTextStyles.styleBold28sp(
              context,
            ).copyWith(color: ColorsTheme().whiteColor),
          ),
          const SizedBox(height: 4),

          // App Tagline
          Text(
            'Your Daily News Source',
            style: TextStyle(
              color: ColorsTheme().whiteColor.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    CategoryWithSubcategories category,
    bool isDarkMode,
  ) {
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
            _getIconData(category.icon),
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
                category.name,
                style: AppTextStyles.styleMedium16sp(context).copyWith(
                  color: isDarkMode
                      ? ColorsTheme().whiteColor.withValues(alpha: 0.95)
                      : Colors.grey[800],
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
        children: category.subcategories.map((subcategory) {
          return _buildSubcategoryTile(
            context,
            subcategory,
            category.name,
            isDarkMode,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSubcategoryTile(
    BuildContext context,
    Subcategory subcategory,
    String categoryName,
    bool isDarkMode,
  ) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
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
          context.push(
            Routes.searchCategoryView,
            extra: '$categoryName - ${subcategory.name}',
          );
        },
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
