import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/tablet_grid_book_opinion_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/vertical_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class TabletOtherCategoriesGrid extends StatelessWidget {
  const TabletOtherCategoriesGrid({
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
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            Routes.detailsArticalView,
                            extra: articles[index],
                          );
                        },
                        child: (categorySlug == 'books_opinions')
                            ? TabletGridBookOpinionCard(
                                articleItem: articles[index],
                              )
                            : TabletGridArticleCard(
                                articleItem: articles[index],
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
