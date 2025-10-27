import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/vertical_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/manger/articles_breaking_news_cubit/articles_breaking_news_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class BreakingNewsArticlesWidget extends StatelessWidget {
  const BreakingNewsArticlesWidget({
    super.key,
    required this.scrollController,
    required this.onRefresh,
  });

  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBreakingNewsCubit, ArticlesBreakingNewsState>(
      builder: (context, state) {
        if (state is ArticlesBreakingNewsLoading) {
          return const VerticalArticlesLoadingSkeleton();
        } else if (state is ArticlesBreakingNewsError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<ArticlesBreakingNewsCubit>().refresh();
            },
          );
        } else if (state is ArticlesBreakingNewsEmpty) {
          return const EmptyArticlesView();
        } else if (state is ArticlesBreakingNewsLoaded ||
            state is ArticlesBreakingNewsLoadingMore) {
          final articles = state is ArticlesBreakingNewsLoaded
              ? state.articles
              : (state as ArticlesBreakingNewsLoadingMore).currentArticles;

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
                          child: CustomArticleItemCard(
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
                if (state is ArticlesBreakingNewsLoadingMore)
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
