import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_bar_category.dart';

part 'articles_horizontal_bar_category_state.dart';

class ArticlesHorizontalBarCategoryCubit
    extends Cubit<ArticlesHorizontalBarCategoryState> {
  ArticlesHorizontalBarCategoryCubit(this._articlesHorizontalBarCategoryRepo)
    : super(ArticlesHorizontalBarCategoryInitial());

  final ArticlesHorizontalBarCategoryRepo _articlesHorizontalBarCategoryRepo;

  // Pagination state
  List<ArticleModel> _allArticles = [];
  int _currentPage = 1;
  int? _totalPages;
  bool _isFetchingMore = false;
  String? _currentCategorySlug;
  String? _currentLanguage;

  Future<void> fetchCategories({
    required String categorySlug,
    required String language,
  }) async {
    emit(ArticlesHorizontalBarCategoryLoading());

    // Reset pagination state for new category
    _allArticles = [];
    _currentPage = 1;
    _totalPages = null;
    _isFetchingMore = false;
    _currentCategorySlug = categorySlug;
    _currentLanguage = language;

    try {
      final result = await _articlesHorizontalBarCategoryRepo
          .getArticlesByCategory(
            categorySlug: categorySlug,
            language: language,
            pageNumber: 1,
          );

      result.fold(
        (failure) {
          emit(ArticlesHorizontalBarCategoryError(failure));
        },
        (articlesData) {
          _allArticles = articlesData.articles ?? [];
          _totalPages = articlesData.totalPages;
          _currentPage = 1;
          emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
        },
      );
    } catch (e) {
      emit(
        ArticlesHorizontalBarCategoryError('Failed to fetch categories: $e'),
      );
    }
  }

  Future<void> loadMoreArticles() async {
    // Prevent multiple simultaneous requests
    if (_isFetchingMore) return;

    // Check if there are more pages to load
    if (_totalPages != null && _currentPage >= _totalPages!) return;

    // Ensure we have category and language
    if (_currentCategorySlug == null || _currentLanguage == null) return;

    _isFetchingMore = true;
    emit(ArticlesHorizontalBarCategoryLoadingMore(_allArticles));

    try {
      final nextPage = _currentPage + 1;
      final result = await _articlesHorizontalBarCategoryRepo
          .getArticlesByCategory(
            categorySlug: _currentCategorySlug!,
            language: _currentLanguage!,
            pageNumber: nextPage,
          );

      result.fold(
        (failure) {
          _isFetchingMore = false;
          // Keep current articles, just show error in a non-intrusive way
          emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
        },
        (articlesData) {
          if (articlesData.articles != null &&
              articlesData.articles!.isNotEmpty) {
            _allArticles.addAll(articlesData.articles!);
            _currentPage = nextPage;
            _totalPages = articlesData.totalPages;
          }
          _isFetchingMore = false;
          emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
        },
      );
    } catch (e) {
      _isFetchingMore = false;
      // Keep current articles even on error
      emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
    }
  }

  Future<void> refreshCategories() async {
    if (_currentCategorySlug == null || _currentLanguage == null) return;

    // Clear cache
    final repo = _articlesHorizontalBarCategoryRepo;
    if (repo is ArticlesHorizontalBarCategoryRepoImpl) {
      repo.clearCache(_currentCategorySlug!);
    }

    // Fetch from beginning
    await fetchCategories(
      categorySlug: _currentCategorySlug!,
      language: _currentLanguage!,
    );
  }
}
