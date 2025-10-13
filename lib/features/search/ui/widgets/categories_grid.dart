import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/features/search/data/category_model.dart';
import 'package:sahifa/features/search/ui/widgets/category_card.dart';

class CategoriesGrid extends StatelessWidget {
  const CategoriesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CategoryModel> categories = [
      CategoryModel(id: 'obituaries', name: 'Obituaries'),
      CategoryModel(id: 'photo_gallery', name: 'Photo Gallery'),
      CategoryModel(id: 'books_opinions', name: 'Books & Opinions'),
      CategoryModel(id: 'economy', name: 'Economy'),
      CategoryModel(id: 'security_courts', name: 'Security & Courts'),
      CategoryModel(id: 'sports', name: 'Sports'),
      CategoryModel(id: 'local_news', name: 'Local News'),
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Al-Thawra Archive - Large Category (full width)
          CategoryCard(
            categoryName: 'Al-Thawra Archive',
            isLarge: true,
            onTap: () {
              // Navigate to Al-Thawra Archive
            },
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
                  context.push(Routes.searchCategoryView, extra: category.name);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
