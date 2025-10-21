import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';

class CustomHorizontalBooksOpinions extends StatelessWidget {
  const CustomHorizontalBooksOpinions({super.key});

  @override
  Widget build(BuildContext context) {
    final ArticleItemModel articlesItems = ArticleItemModel(
      id: '4',
      imageUrl: "https://images.alwatanvoice.com/writers/large/9999501439.jpg",
      title: "trending_article_4_title".tr(),
      category: "books_opinions".tr(),
      categoryId: "books_opinions",
      description: "trending_article_4_description".tr(),
      date: DateTime(2025, 10, 12),
      viewerCount: 250,
    );
    return SizedBox(
      height: 330,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: 5,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.push(Routes.detailsArticalView, extra: articlesItems);
            },
            child: FadeInLeft(
              child: CustomBooksOpinionsItem(articleItem: articlesItems),
            ),
          );
        },
      ),
    );
  }
}
