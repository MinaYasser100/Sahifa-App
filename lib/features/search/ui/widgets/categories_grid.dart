import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/articals_section/data/category_model.dart';
import 'package:sahifa/features/search/ui/widgets/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> categories = [
      CategoryModel(id: 'obituaries', name: 'obituaries'.tr()),
      CategoryModel(id: 'photo_gallery', name: 'photo_gallery'.tr()),
      CategoryModel(id: 'books_opinions', name: 'books_opinions'.tr()),
      CategoryModel(id: 'economy', name: 'economy'.tr()),
      CategoryModel(id: 'security_courts', name: 'security_courts'.tr()),
      CategoryModel(id: 'sports', name: 'sports'.tr()),
      CategoryModel(id: 'local_news', name: 'local_news'.tr()),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Al-Thawra Archive - Large Category (full width)
          FadeInLeft(
            child: CategoryCard(
              categoryName: 'altharwa_archive'.tr(),
              isLarge: true,
              onTap: () {
                context.push(Routes.alThawraArchiveView);
              },
            ),
          ),
          const SizedBox(height: 16),

          // Regular Categories Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return CategoryCard(
                categoryName: category.name,
                onTap: () {
                  context.push(Routes.searchCategoryView, extra: category);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
