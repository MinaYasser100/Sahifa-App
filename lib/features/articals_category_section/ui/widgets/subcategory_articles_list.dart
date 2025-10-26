import 'package:flutter/material.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/artical_list_item.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class SubcategoryArticlesList extends StatelessWidget {
  const SubcategoryArticlesList({super.key, required this.articles});

  final List<ArticleItemModel> articles;

  // Convert ArticleItemModel to ArticleModel
  ArticleModel _convertToArticleModel(ArticleItemModel item) {
    return ArticleModel(
      id: item.id,
      title: item.title,
      summary: item.description,
      image: item.imageUrl,
      categoryName: item.category,
      categoryId: item.categoryId,
      createdAt: item.date.toIso8601String(),
      viewsCount: item.viewerCount,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: articles.isEmpty
          ? const EmptyArticlesView()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                return ArticalListItem(
                  article: _convertToArticleModel(articles[index]),
                );
              },
            ),
    );
  }
}
