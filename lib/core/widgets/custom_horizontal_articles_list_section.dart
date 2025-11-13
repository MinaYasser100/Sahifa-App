import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/horizontal_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/data/repo/articles_home_category_repo.dart';
import 'package:sahifa/features/home/manger/articles_home_category_cubit/articles_home_category_cubit.dart';

class CustomHorizontalArticlesListSection extends StatelessWidget {
  const CustomHorizontalArticlesListSection({
    super.key,
    required this.categorySlug,
    this.articleSlug,
  });

  final String categorySlug;
  final String? articleSlug;

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocProvider(
      create: (context) =>
          ArticlesHomeCategoryCubit(getIt<ArticlesHomeCategoryRepoImpl>())
            ..fetchArticlesHomeByCategory(categorySlug, language),
      child: BlocBuilder<ArticlesHomeCategoryCubit, ArticlesHomeCategoryState>(
        builder: (context, state) {
          // Loading State
          if (state is ArticlesHomeCategoryLoading) {
            return const HorizontalArticlesLoadingSkeleton();
          }

          // Error State
          if (state is ArticlesHomeCategoryError) {
            return SizedBox(
              height: ResponsiveHelper.isTablet(context) ? 400 : 330,
              child: Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          // Success State
          if (state is ArticlesHomeCategorySuccess) {
            final articles = state.articles;

            if (articles.isEmpty) {
              return const SizedBox.shrink();
            }
            final filteredArticles = articleSlug != null
                ? articles
                      .where((article) => article.slug != articleSlug)
                      .toList()
                : articles;

            // If after filtering, no articles left, hide the section
            if (filteredArticles.isEmpty) {
              return const SizedBox.shrink();
            }
            final isTablet = ResponsiveHelper.isTablet(context);
            return SizedBox(
              height: isTablet ? 400 : 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                primary: false,
                itemCount: filteredArticles.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.push(
                        Routes.detailsArticalView,
                        extra: filteredArticles[index],
                      );
                    },
                    child: FadeInLeft(
                      child: CustomArticleItemCard(
                        articleItem: filteredArticles[index],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // Default/Initial State
          return const SizedBox(height: 325);
        },
      ),
    );
  }
}
