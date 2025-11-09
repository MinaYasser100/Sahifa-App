import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';

class AuthorArticlesGrid extends StatelessWidget {
  const AuthorArticlesGrid({super.key, required this.articles});

  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          return GestureDetector(
            onTap: () {
              context.push(Routes.detailsArticalView, extra: articles[index]);
            },
            child: CustomBooksOpinionsItem(
              articleItem: articles[index],
              isItemList: true,
            ),
          );
        }, childCount: articles.length),
      ),
    );
  }
}
