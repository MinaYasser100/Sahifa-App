import 'package:flutter/material.dart';
import 'package:sahifa/features/articals_section/data/category_model.dart';
import 'package:sahifa/features/articals_section/ui/widgets/categories_bar.dart';

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

          // Content Area - هنا هتحط المحتوى اللي انت عايزه
          Expanded(
            child: Center(
              child: Text(
                'Selected: $selectedCategoryId',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
