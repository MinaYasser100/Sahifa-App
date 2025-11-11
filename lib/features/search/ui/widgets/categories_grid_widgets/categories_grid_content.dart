import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/custom_audio_magazine_section.dart';
import 'package:sahifa/core/widgets/galleries_section/galleries_section.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/archive_category_card.dart';
import 'package:sahifa/features/search/ui/widgets/category_card.dart';
import 'package:sahifa/features/search/ui/widgets/tablet_categories_grid.dart';

class CategoriesGridContent extends StatelessWidget {
  final List<CategoryFilterModel> categories;

  const CategoriesGridContent({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);

    if (isTablet) {
      return TabletCategoriesGrid(categories: categories);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ArchiveCategoryCard(),
          const SizedBox(height: 16),
          categories.isEmpty
              ? const CustomAudioMagazineSection(
                  notMargin: true,
                  isDecorated: true,
                )
              : _buildCategoriesWithAudioMagazine(context),
        ],
      ),
    );
  }

  Widget _buildCategoriesWithAudioMagazine(BuildContext context) {
    return Column(
      children: [
        // First row (2 items)
        if (categories.isNotEmpty) _buildFirstRow(context),

        // Audio Magazine Section بعد أول صفين
        const CustomAudioMagazineSection(notMargin: true, isDecorated: true),

        const SizedBox(height: 12),

        // Galleries Section تحت الـ Audio Magazine
        GalleriesSection(
          notMargin: true,
          isDecorated: true,
          onTap: () {
            context.push(Routes.galleriesArticlesWidget);
          },
        ),

        // باقي الـ Grid items
        if (categories.length > 2) _buildRemainingGrid(context),
      ],
    );
  }

  Widget _buildFirstRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CategoryCard(
            categoryName: categories[0].name,
            onTap: () {
              context.push(Routes.searchCategoryView, extra: categories[0]);
            },
          ),
        ),
        const SizedBox(width: 12),
        if (categories.length > 1)
          Expanded(
            child: CategoryCard(
              categoryName: categories[1].name,
              onTap: () {
                context.push(Routes.searchCategoryView, extra: categories[1]);
              },
            ),
          )
        else
          const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget _buildRemainingGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: categories.length - 2,
      itemBuilder: (context, index) {
        final category = categories[index + 2]; // Start from 3rd item
        return CategoryCard(
          categoryName: category.name,
          onTap: () {
            context.push(Routes.searchCategoryView, extra: category);
          },
        );
      },
    );
  }
}
