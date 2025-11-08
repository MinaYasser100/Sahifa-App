import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/core/utils/colors.dart';

class CategoriesHorizontalBarContent extends StatelessWidget {
  const CategoriesHorizontalBarContent({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  final List<ParentCategory> categories;
  final String selectedCategoryId;
  final void Function(CategoryFilterModel category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // الـ 3 عناصر الثابتة
    final List<CategoryFilterModel> fixedCategories = [
      CategoryFilterModel(id: 'home', name: 'home'.tr(), slug: 'home'),
      CategoryFilterModel(
        id: 'Breaking News',
        name: 'Breaking News'.tr(),
        slug: 'breaking-news',
      ),
      CategoryFilterModel(
        id: 'books_opinions',
        name: 'books_opinions'.tr(),
        slug: 'books_opinions',
      ),
    ];

    // الـ API categories جايه جاهزة من الـ Cubit (filtered & sorted)
    final List<CategoryFilterModel> apiCategoryModels = categories
        .map(
          (category) => CategoryFilterModel(
            id: category.id?.toString() ?? '',
            name: category.name ?? '',
            slug: category.slug ?? '',
          ),
        )
        .toList();

    // دمج الـ fixed + API categories
    final allCategories = [...fixedCategories, ...apiCategoryModels];

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryDark
            : ColorsTheme().primaryColor,
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: allCategories.length,
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected = selectedCategoryId == category.id;

          return GestureDetector(
            onTap: () {
              onCategoryTap(category);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: isSelected
                    ? Border(
                        bottom: BorderSide(
                          color: ColorsTheme().whiteColor,
                          style: BorderStyle.solid,
                          width: 2,
                        ),
                      )
                    : null,
              ),
              child: Center(
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: ColorsTheme().whiteColor,
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
