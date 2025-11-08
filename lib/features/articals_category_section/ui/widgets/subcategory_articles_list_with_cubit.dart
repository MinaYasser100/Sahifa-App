import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/articals_category_section/manager/subcategory_articles_cubit/subcategory_articles_cubit.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/all_category_articles_loading.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/articles_list.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class SubcategoryArticlesListWithCubit extends StatelessWidget {
  const SubcategoryArticlesListWithCubit({
    super.key,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubcategoryArticlesCubit, SubcategoryArticlesState>(
      builder: (context, state) {
        if (state is SubcategoryArticlesLoading) {
          return const AllCategoryArticlesLoadingWidget();
        } else if (state is SubcategoryArticlesError) {
          return Expanded(
            child: CustomErrorLoadingWidget(
              message: state.errorMessage,
              onPressed: onRefresh,
            ),
          );
        } else if (state is SubcategoryArticlesEmpty) {
          return const Expanded(child: EmptyArticlesView());
        } else if (state is SubcategoryArticlesLoaded ||
            state is SubcategoryArticlesLoadingMore) {
          final articles = state is SubcategoryArticlesLoaded
              ? state.articles
              : (state as SubcategoryArticlesLoadingMore).currentArticles;
          final hasMore = state is SubcategoryArticlesLoaded
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
