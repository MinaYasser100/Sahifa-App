import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/features/articals_section/data/local_data.dart';
import 'package:sahifa/features/articals_section/ui/widgets/categories_bar.dart';
import 'package:sahifa/features/articals_section/ui/widgets/artical_list_item.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

class ArticlesCategorySectionView extends StatefulWidget {
  const ArticlesCategorySectionView({super.key, required this.title});
  final String title;

  @override
  State<ArticlesCategorySectionView> createState() =>
      _ArticlesCategorySectionViewState();
}

class _ArticlesCategorySectionViewState
    extends State<ArticlesCategorySectionView> {
  String selectedCategoryId = 'all';

  final List<CategoryFilterModel> categories = [
    CategoryFilterModel(id: 'all', name: 'All'.tr(), slug: 'all'),
    CategoryFilterModel(
      id: 'politics',
      name: 'Politics'.tr(),
      slug: 'politics',
    ),
    CategoryFilterModel(id: 'sports', name: 'Sports'.tr(), slug: 'sports'),
    CategoryFilterModel(
      id: 'technology',
      name: 'Technology'.tr(),
      slug: 'technology',
    ),
    CategoryFilterModel(
      id: 'business',
      name: 'Business'.tr(),
      slug: 'business',
    ),
  ];

  List<ArticleItemModel> get filteredArticles {
    if (selectedCategoryId == 'all') {
      // Merge all articles from all categories
      return articlesByCategory.values.expand((articles) => articles).toList()
        ..sort((a, b) => b.date.compareTo(a.date));
    }
    return articlesByCategory[selectedCategoryId] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), elevation: 0),
      body: Column(
        children: [
          // Categories Bar
          CategoriesBar(
            categories: categories,
            selectedCategoryId: selectedCategoryId,
            onCategorySelected: (categoryId) {
              setState(() {
                selectedCategoryId = categoryId;
              });
            },
          ),

          // Articles List
          Expanded(
            child: filteredArticles.isEmpty
                ? Center(
                    child: Text(
                      'no_articles_in_this_category'.tr(),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
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
      ),
    );
  }
}
