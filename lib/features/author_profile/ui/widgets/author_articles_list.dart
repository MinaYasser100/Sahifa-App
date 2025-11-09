import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';

class AuthorArticlesList extends StatelessWidget {
  const AuthorArticlesList({super.key, required this.articles});

  final List<ArticleModel> articles;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                context.push(Routes.detailsArticalView, extra: articles[index]);
              },
              child: CustomBooksOpinionsItem(
                articleItem: articles[index],
                cardWidth: double.infinity,
                isItemList: true,
              ),
            ),
          );
        }, childCount: articles.length),
      ),
    );
  }
}
