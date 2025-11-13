import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/language_helper.dart';
import 'package:sahifa/core/widgets/custom_books_opinions/custom_books_opinions.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/core/widgets/vertical_articles_loading_skeleton.dart';
import 'package:sahifa/features/home/manger/articles_books_opinioins_bar_category_cubit/articles_books_opinions_bar_category_cubit.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';

class BooksOpinionsArticlesWidget extends StatelessWidget {
  const BooksOpinionsArticlesWidget({
    super.key,
    required this.scrollController,
    required this.onRefresh,
  });

  final ScrollController scrollController;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final language = LanguageHelper.getCurrentLanguageCode(context);

    return BlocBuilder<
      ArticlesBooksOpinionsBarCategoryCubit,
      ArticlesBooksOpinionsBarCategoryState
    >(
      builder: (context, state) {
        if (state is ArticlesBooksOpinionsBarCategoryLoading) {
          return const VerticalArticlesLoadingSkeleton();
        } else if (state is ArticlesBooksOpinionsBarCategoryError) {
          return CustomErrorLoadingWidget(
            message: state.message,
            onPressed: () {
              context.read<ArticlesBooksOpinionsBarCategoryCubit>().refresh(
                language: language,
              );
            },
          );
        } else if (state is ArticlesBooksOpinionsBarCategoryLoaded) {
          final articles = state.articles;

          if (articles.isEmpty) {
            return const EmptyArticlesView();
          }

          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(10),
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
                          child: CustomBooksOpinionsItem(
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
                if (state.hasMorePages)
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
