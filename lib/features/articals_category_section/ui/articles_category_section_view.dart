import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/features/articals_category_section/data/local_data.dart';
import 'package:sahifa/features/articals_category_section/data/repo/horizontal_bar_subcategories.dart';
import 'package:sahifa/features/articals_category_section/manager/horizontal_bar_subcategories_cubit/horizontal_bar_subcategories_cubit.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/categories_bar.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/artical_list_item.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

class ArticlesCategorySectionView extends StatefulWidget {
  const ArticlesCategorySectionView({super.key, required this.parentCategory});
  final ParentCategory parentCategory;

  @override
  State<ArticlesCategorySectionView> createState() =>
      _ArticlesCategorySectionViewState();
}

class _ArticlesCategorySectionViewState
    extends State<ArticlesCategorySectionView> {
  String _selectedCategorySlug = 'all';
  late HorizontalBarSubcategoriesCubit _cubit;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _cubit = HorizontalBarSubcategoriesCubit(
        getIt<HorizontalBarSubcategoriesRepoImpl>(),
      );
      _cubit.fetchSubcategories(
        widget.parentCategory.slug!,
        context.locale.languageCode,
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  List<ArticleItemModel> get filteredArticles {
    if (_selectedCategorySlug == 'all') {
      // Merge all articles from all categories
      return articlesByCategory.values.expand((articles) => articles).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    return articlesByCategory[_selectedCategorySlug] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.parentCategory.name!), elevation: 0),
        body:
            BlocBuilder<
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

                    // Articles List
                    Expanded(
                      child: filteredArticles.isEmpty
                          ? Center(
                              child: Text(
                                'no_articles_in_this_category'.tr(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredArticles.length,
                              itemBuilder: (context, index) {
                                return ArticalListItem(
                                  articleItem: filteredArticles[index],
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
      ),
    );
  }
}
