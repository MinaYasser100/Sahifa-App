import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/custom_article_item_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/home/manger/galeries_posts_cubit/galeries_posts_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/tablet_grid_articles_skeleton.dart';

class TabletGaleriesGrid extends StatelessWidget {
  const TabletGaleriesGrid({
    super.key,
    required this.scrollController,
    required this.onRefresh,
  });

  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GaleriesPostsCubit, GaleriesPostsState>(
      builder: (context, state) {
        if (state is GaleriesPostsLoading) {
          return const TabletGridArticlesSkeleton();
        } else if (state is GaleriesPostsError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<GaleriesPostsCubit>().refresh();
            },
          );
        } else if (state is GaleriesPostsLoaded ||
            state is GaleriesPostsLoadingMore) {
          final articles = state is GaleriesPostsLoaded
              ? state.articles
              : (state as GaleriesPostsLoadingMore).currentArticles;

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
                        child: CustomArticleItemCard(
                          articleItem: articles[index],
                          cardWidth: double.infinity,
                          isItemList: false,
                        ),
                      );
                    }, childCount: articles.length),
                  ),
                ),
                // Loading indicator for pagination
                if (state is GaleriesPostsLoadingMore)
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
