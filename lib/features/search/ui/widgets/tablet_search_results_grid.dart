import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/tablet_grid_book_opinion_card.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/search/ui/manager/search_articles_cubit/search_articles_cubit.dart';
import 'package:sahifa/features/search/ui/widgets/tablet_search_skeleton.dart';

class TabletSearchResultsGrid extends StatelessWidget {
  const TabletSearchResultsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchArticlesCubit, SearchArticlesState>(
      builder: (context, state) {
        if (state is SearchArticlesLoadingState) {
          return const SliverToBoxAdapter(child: TabletSearchSkeleton());
        } else if (state is SearchArticlesErrorState) {
          return SliverFillRemaining(
            child: CustomErrorLoadingWidget(
              message: state.message,
              onPressed: () {},
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
            padding: const EdgeInsets.all(24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final article = articles[index];
                  final isBookOpinion = article.categorySlug == 'books_opinions';

                  return GestureDetector(
                    onTap: () {
                      context.push(
                        Routes.detailsArticalView,
                        extra: article,
                      );
                    },
                    child: isBookOpinion
                        ? TabletGridBookOpinionCard(articleItem: article)
                        : TabletGridArticleCard(articleItem: article),
                  );
                },
                childCount: articles.length,
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
