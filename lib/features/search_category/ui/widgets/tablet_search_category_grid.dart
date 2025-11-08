import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_article_item/tablet_grid_article_card.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/tablet_grid_book_opinion_card.dart';
import 'package:sahifa/features/search_category/manager/articles_search_category_cubit/articles_search_category_cubit.dart';

class TabletSearchCategoryGrid extends StatefulWidget {
  const TabletSearchCategoryGrid({
    super.key,
    required this.articles,
    required this.hasMore,
    required this.isBookOpinion,
  });

  final List<ArticleModel> articles;
  final bool hasMore;
  final bool isBookOpinion;

  @override
  State<TabletSearchCategoryGrid> createState() =>
      _TabletSearchCategoryGridState();
}

class _TabletSearchCategoryGridState extends State<TabletSearchCategoryGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      if (widget.hasMore) {
        try {
          context.read<ArticlesSearchCategoryCubit>().loadMore();
        } catch (e) {
          // Handle error safely
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index < widget.articles.length) {
                final article = widget.articles[index];
                return GestureDetector(
                  onTap: () {
                    context.push(Routes.detailsArticalView, extra: article);
                  },
                  child: widget.isBookOpinion
                      ? TabletGridBookOpinionCard(articleItem: article)
                      : TabletGridArticleCard(articleItem: article),
                );
              }
              return null;
            }, childCount: widget.articles.length),
          ),
        ),
        if (widget.hasMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
