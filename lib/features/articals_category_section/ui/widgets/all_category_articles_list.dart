import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/articals_category_section/manager/all_category_articles_cubit/all_category_articles_cubit.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/all_category_articles_loading.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/articles_list.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class AllCategoryArticlesList extends StatelessWidget {
  const AllCategoryArticlesList({
    super.key,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AllCategoryArticlesCubit, AllCategoryArticlesState>(
      builder: (context, state) {
        if (state is AllCategoryArticlesLoading) {
          return const AllCategoryArticlesLoadingWidget();
        } else if (state is AllCategoryArticlesError) {
          return Expanded(
            child: CustomErrorLoadingWidget(
              message: state.errorMessage,
              onPressed: onRefresh,
            ),
          );
        } else if (state is AllCategoryArticlesEmpty) {
          return const Expanded(child: EmptyArticlesView());
        } else if (state is AllCategoryArticlesLoaded ||
            state is AllCategoryArticlesLoadingMore) {
          final articles = state is AllCategoryArticlesLoaded
              ? state.articles
              : (state as AllCategoryArticlesLoadingMore).currentArticles;
          final hasMore = state is AllCategoryArticlesLoaded
              ? state.hasMore
              : true;

          return ArticlesList(
            articles: articles,
            hasMore: hasMore,
            onLoadMore: onLoadMore,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
