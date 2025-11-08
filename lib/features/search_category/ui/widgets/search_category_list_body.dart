import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/search_category/manager/articles_search_category_cubit/articles_search_category_cubit.dart';
import 'package:sahifa/features/search_category/ui/widgets/search_category_article_item.dart';

class SearchCategoryListBody extends StatefulWidget {
  const SearchCategoryListBody({
    super.key,
    required this.articles,
    required this.hasMore,
    required this.isBookOpinion,
  });

  final List<ArticleModel> articles;
  final bool hasMore;
  final bool isBookOpinion;

  @override
  State<SearchCategoryListBody> createState() => _SearchCategoryListBodyState();
}

class _SearchCategoryListBodyState extends State<SearchCategoryListBody> {
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
      // Load more when 90% scrolled
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
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (index < widget.articles.length) {
                return SearchCategoryArticleItem(
                  articleItem: widget.articles[index],
                  isBookOpinion: widget.isBookOpinion,
                );
              }
              return null;
            }, childCount: widget.articles.length),
          ),
        ),
        // Loading more indicator
        if (widget.hasMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
