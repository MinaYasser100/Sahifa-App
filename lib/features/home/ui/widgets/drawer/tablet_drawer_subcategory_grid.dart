import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/tablet_grid_book_opinion_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/home/manger/articles_drawer_subcategory_cubit/articles_drawer_subcategory_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_subcategory_content.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/empty_articles_state.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/tablet_drawer_skeleton.dart';

class TabletDrawerSubcategoryGrid extends StatelessWidget {
  const TabletDrawerSubcategoryGrid({
    super.key,
    required this.widget,
    required this.language,
    required ScrollController scrollController,
  }) : _scrollController = scrollController;

  final DrawerSubCategoryContentView widget;
  final String language;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ArticlesDrawerSubcategoryCubit,
      ArticlesDrawerSubcategoryState
    >(
      builder: (context, state) {
        if (state is ArticlesDrawerSubcategoryLoading) {
          return const TabletDrawerSkeleton();
        }

        if (state is ArticlesDrawerSubcategoryError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<ArticlesDrawerSubcategoryCubit>().fetchArticles(
                categorySlug: widget.subcategory.slug ?? '',
                language: language,
              );
            },
          );
        }

        if (state is ArticlesDrawerSubcategoryLoaded ||
            state is ArticlesDrawerSubcategoryLoadingMore) {
          final articles = state is ArticlesDrawerSubcategoryLoaded
              ? state.articles
              : (state as ArticlesDrawerSubcategoryLoadingMore).articles;

          if (articles.isEmpty) {
            return EmptyArticlesState(
              categoryName: widget.subcategory.name ?? '',
            );
          }

          final categorySlug = widget.subcategory.slug ?? '';

          return CustomScrollView(
            controller: _scrollController,
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
              if (state is ArticlesDrawerSubcategoryLoadingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
