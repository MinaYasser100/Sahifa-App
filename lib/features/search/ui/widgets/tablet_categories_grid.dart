import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_audio_magazine_section/custom_audio_magazine_section.dart';
import 'package:sahifa/features/search/ui/widgets/categories_grid_widgets/archive_category_card.dart';
import 'package:sahifa/features/search/ui/widgets/category_card.dart';

class TabletCategoriesGrid extends StatelessWidget {
  final List<CategoryFilterModel> categories;

  const TabletCategoriesGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ArchiveCategoryCard(),
          const SizedBox(height: 20),
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
        if (categories.isNotEmpty) _buildFirstRow(context),
        const SizedBox(height: 20),
        const CustomAudioMagazineSection(notMargin: true, isDecorated: true),
        const SizedBox(height: 20),
        if (categories.length > 3) _buildRemainingGrid(context),
      ],
    );
  }

  Widget _buildFirstRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.5,
            child: CategoryCard(
              categoryName: categories[0].name,
              onTap: () {
                context.push(Routes.searchCategoryView, extra: categories[0]);
              },
            ),
          ),
        ),
        const SizedBox(width: 16),
        if (categories.length > 1)
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: CategoryCard(
                categoryName: categories[1].name,
                onTap: () {
                  context.push(Routes.searchCategoryView, extra: categories[1]);
                },
              ),
            ),
          )
        else
          const Expanded(child: SizedBox()),
        const SizedBox(width: 16),
        if (categories.length > 2)
          Expanded(
            child: AspectRatio(
              aspectRatio: 1.5,
              child: CategoryCard(
                categoryName: categories[2].name,
                onTap: () {
                  context.push(Routes.searchCategoryView, extra: categories[2]);
                },
              ),
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
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: categories.length - 3,
      itemBuilder: (context, index) {
        final category = categories[index + 3];
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
