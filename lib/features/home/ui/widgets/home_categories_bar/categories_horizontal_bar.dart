import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/search/data/category_model.dart';

class CategoriesHorizontalBar extends StatelessWidget {
  const CategoriesHorizontalBar({
    super.key,
    required this.selectedCategoryId,
    required this.onCategoryTap,
  });

  final String selectedCategoryId;
  final void Function(CategoryModel category) onCategoryTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final List<CategoryModel> categories = [
      CategoryModel(id: 'home', name: 'home'.tr()),
      CategoryModel(id: 'Breaking News', name: 'Breaking News'.tr()),
      CategoryModel(id: 'obituaries', name: 'obituaries'.tr()),
      CategoryModel(id: 'photo_gallery', name: 'photo_gallery'.tr()),
      CategoryModel(id: 'books_opinions', name: 'books_opinions'.tr()),
      CategoryModel(id: 'economy', name: 'economy'.tr()),
      CategoryModel(id: 'security_courts', name: 'security_courts'.tr()),
      CategoryModel(id: 'sports', name: 'sports'.tr()),
      CategoryModel(id: 'local_news', name: 'local_news'.tr()),
    ];

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
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
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
