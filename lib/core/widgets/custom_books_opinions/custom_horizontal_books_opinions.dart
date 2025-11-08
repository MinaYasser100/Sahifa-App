import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';

class CustomHorizontalBooksOpinions extends StatelessWidget {
  const CustomHorizontalBooksOpinions({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    final ArticleModel articlesItems = ArticleModel(
      authorName: "Author Name",
      categoryName: "category_economy".tr(),
      createdAt: "2025-10-13T12:34:56",
      id: '1',
      image:
          'https://althawra-news.net/user_images/news/26-08-25-179659767.jpg',
      imageDescription: "Description of trending article 1",
      isBreaking: false,
      isFeatured: true,
      isRecommended: false,
      isSlider: false,
      title: 'trending_article_1_title'.tr(),
      language: "ar",
      likesCount: 361125,
      publishedAt: "2025-10-13T12:34:56",
      slug: "category_economy".tr(),
      status: "published",
      description: "trending_article_1_description".tr(),
      categoryId: 'category_economy',
      viewsCount: 50000,
    );
    return SizedBox(
      height: isTablet ? 400 : 330,
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
