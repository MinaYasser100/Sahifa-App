import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/article_skeleton_card.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/search/manager/search_articles_cubit/search_articles_cubit.dart';
import 'package:sahifa/features/search/ui/widgets/tablet_search_results_grid.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = ResponsiveHelper.isTablet(context);
    
    if (isTablet) {
      return const TabletSearchResultsGrid();
    }
    
    return BlocBuilder<SearchArticlesCubit, SearchArticlesState>(
      builder: (context, state) {
        if (state is SearchArticlesLoadingState) {
          return SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const ArticleSkeletonCard(),
                childCount: 5,
              ),
            ),
          );
        } else if (state is SearchArticlesErrorState) {
          return SliverFillRemaining(
            child: CustomErrorLoadingWidget(
              message: state.message,
              onPressed: () {
                // Retry search - you might need to pass query here
              },
            ),
          );
        } else if (state is SearchArticlesLoadedState) {
          final articles = state.articles;

          if (articles.isEmpty) {
            return const SliverFillRemaining(
              child: Center(child: Text('No articles found')),
            );
          }

          return SliverPadding(
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
          );
        }

        // Initial state - return empty
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
