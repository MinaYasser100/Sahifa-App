import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/features/articals_category_section/manager/horizontal_bar_subcategories_cubit/horizontal_bar_subcategories_cubit.dart';
import 'package:sahifa/features/articals_category_section/manager/subcategory_articles_cubit/subcategory_articles_cubit.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/all_category_articles_list.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/categories_bar.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/subcategory_articles_list_with_cubit.dart';

class CategoriesSectionBody extends StatefulWidget {
  const CategoriesSectionBody({
    super.key,
    required this.parentCategorySlug,
    required this.onAllRefresh,
    required this.onAllLoadMore,
    required this.onSubcategoryRefresh,
    required this.onSubcategoryLoadMore,
  });

  final String parentCategorySlug;
  final Future<void> Function() onAllRefresh;
  final VoidCallback onAllLoadMore;
  final Future<void> Function() onSubcategoryRefresh;
  final VoidCallback onSubcategoryLoadMore;

  @override
  State<CategoriesSectionBody> createState() => _CategoriesSectionBodyState();
}

class _CategoriesSectionBodyState extends State<CategoriesSectionBody> {
  String _selectedCategorySlug = 'all';

  @override
  void didUpdateWidget(CategoriesSectionBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If category slug changed and we're not on "all", fetch new data
    if (_selectedCategorySlug != 'all') {
      _fetchSubcategoryArticles();
    }
  }

  void _fetchSubcategoryArticles() {
    context.read<SubcategoryArticlesCubit>().fetchSubcategoryArticles(
      language: context.locale.languageCode,
      categorySlug: _selectedCategorySlug,
    );
  }

  void _onCategorySelected(String categorySlug) {
    setState(() {
      _selectedCategorySlug = categorySlug;
    });

    // Fetch articles when subcategory is selected
    if (categorySlug != 'all') {
      _fetchSubcategoryArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      HorizontalBarSubcategoriesCubit,
      HorizontalBarSubcategoriesState
    >(
      builder: (context, state) {
        // Build categories list with "All" as first item
        final List<CategoryFilterModel> categories = [
          CategoryFilterModel(id: 'all', name: 'All'.tr(), slug: 'all'),
        ];

        if (state is HorizontalBarSubcategoriesLoaded) {
          // Add subcategories from API
          categories.addAll(
            state.subcategories.map(
              (sub) => CategoryFilterModel(
                id: sub.id ?? '',
                name: sub.name ?? '',
                slug: sub.slug ?? '',
              ),
            ),
          );
        }

        return Column(
          children: [
            // Categories Bar
            if (state is HorizontalBarSubcategoriesLoading)
              const LinearProgressIndicator()
            else
              CategoriesBar(
                categories: categories,
                selectedCategoryId: _selectedCategorySlug,
                onCategorySelected: _onCategorySelected,
              ),

            // Articles List - Show All Category Articles when "all" is selected
            if (_selectedCategorySlug == 'all')
              AllCategoryArticlesList(
                onRefresh: widget.onAllRefresh,
                onLoadMore: widget.onAllLoadMore,
              )
            else
              SubcategoryArticlesListWithCubit(
                onRefresh: widget.onSubcategoryRefresh,
                onLoadMore: widget.onSubcategoryLoadMore,
              ),
          ],
        );
      },
    );
  }
}
