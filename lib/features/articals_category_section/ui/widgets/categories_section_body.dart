import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/features/articals_category_section/data/local_data.dart';
import 'package:sahifa/features/articals_category_section/manager/horizontal_bar_subcategories_cubit/horizontal_bar_subcategories_cubit.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/all_category_articles_list.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/categories_bar.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/subcategory_articles_list.dart';

class CategoriesSectionBody extends StatefulWidget {
  const CategoriesSectionBody({
    super.key,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  State<CategoriesSectionBody> createState() => _CategoriesSectionBodyState();
}

class _CategoriesSectionBodyState extends State<CategoriesSectionBody> {
  String _selectedCategorySlug = 'all';

  List<ArticleItemModel> get _filteredArticles {
    if (_selectedCategorySlug == 'all') {
      // Merge all articles from all categories
      return articlesByCategory.values.expand((articles) => articles).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    return articlesByCategory[_selectedCategorySlug] ?? [];
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
                onCategorySelected: (categorySlug) {
                  setState(() {
                    _selectedCategorySlug = categorySlug;
                  });
                },
              ),

            // Articles List - Show All Category Articles when "all" is selected
            if (_selectedCategorySlug == 'all')
              AllCategoryArticlesList(
                onRefresh: widget.onRefresh,
                onLoadMore: widget.onLoadMore,
              )
            else
              SubcategoryArticlesList(articles: _filteredArticles),
          ],
        );
      },
    );
  }
}
