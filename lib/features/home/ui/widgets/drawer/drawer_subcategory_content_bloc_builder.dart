import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/home/manger/articles_drawer_subcategory_cubit/articles_drawer_subcategory_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/drawer_subcategory_content.dart';
import 'package:sahifa/features/home/ui/widgets/drawer/empty_articles_state.dart';

class DrawerSubCategoryContentBlocBuider extends StatelessWidget {
  const DrawerSubCategoryContentBlocBuider({
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
          return const Center(child: CircularProgressIndicator());
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

          return CustomScrollView(
            controller: _scrollController,
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
                        child: CustomArticleItemCard(
                          articleItem: articles[index],
                        ),
                      ),
                    );
                  }, childCount: articles.length),
                ),
              ),
              // Loading more indicator
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
