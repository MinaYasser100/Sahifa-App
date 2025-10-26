import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/dependency_injection/set_up_dependencies.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/features/articals_category_section/data/repo/all_category_articles_repo.dart';
import 'package:sahifa/features/articals_category_section/data/repo/horizontal_bar_subcategories.dart';
import 'package:sahifa/features/articals_category_section/manager/all_category_articles_cubit/all_category_articles_cubit.dart';
import 'package:sahifa/features/articals_category_section/manager/horizontal_bar_subcategories_cubit/horizontal_bar_subcategories_cubit.dart';
import 'package:sahifa/features/articals_category_section/ui/widgets/categories_section_body.dart';

class ArticlesCategorySectionView extends StatefulWidget {
  const ArticlesCategorySectionView({super.key, required this.parentCategory});
  final ParentCategory parentCategory;

  @override
  State<ArticlesCategorySectionView> createState() =>
      _ArticlesCategorySectionViewState();
}

class _ArticlesCategorySectionViewState
    extends State<ArticlesCategorySectionView> {
  late HorizontalBarSubcategoriesCubit _subcategoriesCubit;
  late AllCategoryArticlesCubit _allArticlesCubit;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _subcategoriesCubit = HorizontalBarSubcategoriesCubit(
        getIt<HorizontalBarSubcategoriesRepoImpl>(),
      );
      _subcategoriesCubit.fetchSubcategories(
        widget.parentCategory.slug!,
        context.locale.languageCode,
      );

      _allArticlesCubit = AllCategoryArticlesCubit(
        getIt<AllCategoryArticlesRepoImpl>(),
      );
      _allArticlesCubit.fetchAllCategoryArticles(
        language: context.locale.languageCode,
        categorySlug: widget.parentCategory.slug!,
      );

      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _subcategoriesCubit.close();
    _allArticlesCubit.close();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _allArticlesCubit.refresh();
  }

  void _handleLoadMore() {
    _allArticlesCubit.loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _subcategoriesCubit),
        BlocProvider.value(value: _allArticlesCubit),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(widget.parentCategory.name!), elevation: 0),
        body: CategoriesSectionBody(
          onRefresh: _handleRefresh,
          onLoadMore: _handleLoadMore,
        ),
      ),
    );
  }
}
