import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/search/ui/manager/search_articles_cubit/search_articles_cubit.dart';

class SearchResultsWidget extends StatelessWidget {
  const SearchResultsWidget({super.key});

  Widget _buildSkeletonArticleCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryColor.withValues(alpha: 0.1)
            : ColorsTheme().primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image skeleton
          Container(
            width: double.infinity,
            height: 220,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                  : ColorsTheme().primaryLight.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.image_outlined,
                size: 64,
                color: isDarkMode
                    ? ColorsTheme().primaryColor.withValues(alpha: 0.3)
                    : ColorsTheme().primaryLight.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category name skeleton
                Container(
                  width: 100,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
                // Article title skeleton (2 lines)
                Container(
                  width: double.infinity,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 250,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? ColorsTheme().primaryColor.withValues(alpha: 0.2)
                        : ColorsTheme().primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<SearchArticlesCubit, SearchArticlesState>(
      builder: (context, state) {
        if (state is SearchArticlesLoadingState) {
          return SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildSkeletonArticleCard(isDarkMode),
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
