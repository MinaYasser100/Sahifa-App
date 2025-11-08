import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/category_model/category_model.dart';
import 'package:sahifa/core/utils/responsive_helper.dart';
import 'package:sahifa/core/widgets/custom_error_loading_widget.dart';
import 'package:sahifa/features/home/ui/widgets/home_categories_bar/empty_articles_view.dart';
import 'package:sahifa/features/search_category/data/repo/articles_search_category_repo.dart';
import 'package:sahifa/features/search_category/manager/articles_search_category_cubit/articles_search_category_cubit.dart';
import 'package:sahifa/features/search_category/ui/widgets/search_category_list_body.dart';
import 'package:sahifa/features/search_category/ui/widgets/search_category_loading_widget.dart';
import 'package:sahifa/features/search_category/ui/widgets/tablet_search_category_grid.dart';
import 'package:sahifa/features/search_category/ui/widgets/tablet_search_category_skeleton.dart';

class SearchCategoryView extends StatefulWidget {
  const SearchCategoryView({super.key, required this.category});
  final CategoryFilterModel category;

  @override
  State<SearchCategoryView> createState() => _SearchCategoryViewState();
}

class _SearchCategoryViewState extends State<SearchCategoryView> {
  late ArticlesSearchCategoryCubit _cubit;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _cubit = ArticlesSearchCategoryCubit(
        getIt<ArticlesSearchCategoryRepoImpl>(),
      );
      _cubit.fetchSearchCategories(
        language: context.locale.languageCode,
        categorySlug: widget.category.slug,
      );
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBookOpinion = widget.category.id == 'books_opinions';
    final isTablet = ResponsiveHelper.isTablet(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.category.name), elevation: 0),
        body:
            BlocBuilder<
              ArticlesSearchCategoryCubit,
              ArticlesSearchCategoryState
            >(
              builder: (context, state) {
                if (state is ArticlesSearchCategoryLoading) {
                  return isTablet
                      ? const TabletSearchCategorySkeleton()
                      : const SearchCategoryLoadingWidget();
                } else if (state is ArticlesSearchCategoryError) {
                  return CustomErrorLoadingWidget(
                    message: state.error.toString(),
                    onPressed: () {
                      context.read<ArticlesSearchCategoryCubit>().refresh();
                    },
                  );
                } else if (state is ArticlesSearchCategoryEmpty) {
                  return const EmptyArticlesView();
                } else if (state is ArticlesSearchCategoryLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      await context
                          .read<ArticlesSearchCategoryCubit>()
                          .refresh();
                    },
                    child: isTablet
                        ? TabletSearchCategoryGrid(
                            articles: state.articles,
                            hasMore: state.hasMore,
                            isBookOpinion: isBookOpinion,
                          )
                        : SearchCategoryListBody(
                            articles: state.articles,
                            hasMore: state.hasMore,
                            isBookOpinion: isBookOpinion,
                          ),
                  );
                } else if (state is ArticlesSearchCategoryLoadingMore) {
                  return isTablet
                      ? TabletSearchCategoryGrid(
                          articles: state.currentArticles,
                          hasMore: true,
                          isBookOpinion: isBookOpinion,
                        )
                      : SearchCategoryListBody(
                          articles: state.currentArticles,
                          hasMore: true,
                          isBookOpinion: isBookOpinion,
                        );
                }

                return const SizedBox();
              },
            ),
      ),
    );
  }
}
