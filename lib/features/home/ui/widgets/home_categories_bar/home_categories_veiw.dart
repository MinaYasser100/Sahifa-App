import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';
import 'package:sahifa/features/home/manger/articles_horizontal_bar_category_cubit/articles_horizontal_bar_category_cubit.dart';

import 'empty_articles_view.dart';

class HomeCategoriesView extends StatefulWidget {
  const HomeCategoriesView({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  State<HomeCategoriesView> createState() => _HomeCategoriesViewState();
}

class _HomeCategoriesViewState extends State<HomeCategoriesView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    log('categorySlug: ${widget.categorySlug}');
    // Fetch articles on first load
    _fetchArticles();
  }

  @override
  void didUpdateWidget(HomeCategoriesView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fetch new articles when categorySlug changes
    if (oldWidget.categorySlug != widget.categorySlug) {
      log(
        'Category changed from ${oldWidget.categorySlug} to ${widget.categorySlug}',
      );
      _fetchArticles();
    }
  }

  void _fetchArticles() {
    final cubit = context.read<ArticlesHorizontalBarCategoryCubit>();
    cubit.fetchCategories(
      categorySlug: widget.categorySlug,
      language: context.locale.languageCode,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<ArticlesHorizontalBarCategoryCubit>().loadMoreArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      ArticlesHorizontalBarCategoryCubit,
      ArticlesHorizontalBarCategoryState
    >(
      builder: (context, state) {
        if (state is ArticlesHorizontalBarCategoryLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ArticlesHorizontalBarCategoryError) {
          return Center(child: Text(state.message));
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
            onRefresh: () async {
              await context
                  .read<ArticlesHorizontalBarCategoryCubit>()
                  .refreshCategories();
            },
            child: CustomScrollView(
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
                          child: (widget.categorySlug == 'books_opinions')
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
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
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
