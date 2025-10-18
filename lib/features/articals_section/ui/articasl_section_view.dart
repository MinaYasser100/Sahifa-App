import 'package:flutter/material.dart';
import 'package:sahifa/features/articals_section/data/category_model.dart';
import 'package:sahifa/features/articals_section/data/local_data.dart';
import 'package:sahifa/features/articals_section/ui/widgets/categories_bar.dart';
import 'package:sahifa/features/articals_section/ui/widgets/artical_list_item.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';

class ArticalsSectionView extends StatefulWidget {
  const ArticalsSectionView({super.key, required this.title});
  final String title;

  @override
  State<ArticalsSectionView> createState() => _ArticalsSectionViewState();
}

class _ArticalsSectionViewState extends State<ArticalsSectionView> {
  String selectedCategoryId = 'all';

  final List<CategoryModel> categories = [
    CategoryModel(id: 'all', name: 'All'),
    CategoryModel(id: 'politics', name: 'Politics'),
    CategoryModel(id: 'sports', name: 'Sports'),
    CategoryModel(id: 'technology', name: 'Technology'),
    CategoryModel(id: 'business', name: 'Business'),
    CategoryModel(id: 'health', name: 'Health'),
    CategoryModel(id: 'entertainment', name: 'Entertainment'),
    CategoryModel(id: 'science', name: 'Science'),
    CategoryModel(id: 'world', name: 'World'),
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
                ? const Center(
                    child: Text(
                      'No articles in this category',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
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
