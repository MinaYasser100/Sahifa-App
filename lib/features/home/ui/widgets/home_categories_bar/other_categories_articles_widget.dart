import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/vertical_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class OtherCategoriesArticlesWidget extends StatelessWidget {
  const OtherCategoriesArticlesWidget({
    super.key,
    required this.categorySlug,
    required this.scrollController,
    required this.onRefresh,
  });

  final String categorySlug;
  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ArticlesHorizontalBarCategoryCubit,
      ArticlesHorizontalBarCategoryState
    >(
      builder: (context, state) {
        if (state is ArticlesHorizontalBarCategoryLoading) {
          return const VerticalArticlesLoadingSkeleton();
        } else if (state is ArticlesHorizontalBarCategoryError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context
                  .read<ArticlesHorizontalBarCategoryCubit>()
                  .refreshCategories();
            },
          );
        } else if (state is ArticlesHorizontalBarCategorySuccess ||
            state is ArticlesHorizontalBarCategoryLoadingMore) {
          final articles = state is ArticlesHorizontalBarCategorySuccess
              ? state.articles
              : (state as ArticlesHorizontalBarCategoryLoadingMore)
                    .currentArticles;

          // Show empty state if no articles
          if (articles.isEmpty) {
            return const EmptyArticlesView();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            context.push(
                              Routes.detailsArticalView,
                              extra: articles[index],
                            );
                          },
                          child: (categorySlug == 'books_opinions')
                              ? CustomBooksOpinionsItem(
                                  articleItem: articles[index],
                                  cardWidth: double.infinity,
                                  isItemList: true,
                                )
                              : CustomArticleItemCard(
                                  articleItem: articles[index],
                                  cardWidth: double.infinity,
                                  isItemList: true,
                                ),
                        ),
                      );
                    }, childCount: articles.length),
                  ),
                ),
                // Loading indicator for pagination
                if (state is ArticlesHorizontalBarCategoryLoadingMore)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          );
        }

        return const EmptyArticlesView();
      },
    );
  }
}
