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
    // Don't proceed if cubit is closed
    if (isClosed) return;

    if (!isClosed) emit(ArticlesHorizontalBarCategoryLoading());

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

      if (isClosed) return;

      result.fold(
        (failure) {
          if (!isClosed) emit(ArticlesHorizontalBarCategoryError(failure));
        },
        (articlesData) {
          _allArticles = articlesData.articles ?? [];
          _totalPages = articlesData.totalPages;
          _currentPage = 1;
          if (!isClosed) {
            emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(
          ArticlesHorizontalBarCategoryError('Failed to fetch categories: $e'),
        );
      }
    }
  }

  Future<void> loadMoreArticles() async {
    // Don't proceed if cubit is closed
    if (isClosed) return;

    // Prevent multiple simultaneous requests
    if (_isFetchingMore) return;

    // Check if there are more pages to load
    if (_totalPages != null && _currentPage >= _totalPages!) return;

    // Ensure we have category and language
    if (_currentCategorySlug == null || _currentLanguage == null) return;

    _isFetchingMore = true;
    if (!isClosed) {
      emit(ArticlesHorizontalBarCategoryLoadingMore(_allArticles));
    }

    try {
      final nextPage = _currentPage + 1;
      final result = await _articlesHorizontalBarCategoryRepo
          .getArticlesByCategory(
            categorySlug: _currentCategorySlug!,
            language: _currentLanguage!,
            pageNumber: nextPage,
          );

      if (isClosed) return;

      result.fold(
        (failure) {
          _isFetchingMore = false;
          // Keep current articles, just show error in a non-intrusive way
          if (!isClosed) {
            emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
          }
        },
        (articlesData) {
          if (articlesData.articles != null &&
              articlesData.articles!.isNotEmpty) {
            _allArticles.addAll(articlesData.articles!);
            _currentPage = nextPage;
            _totalPages = articlesData.totalPages;
          }
          _isFetchingMore = false;
          if (!isClosed) {
            emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
          }
        },
      );
    } catch (e) {
      _isFetchingMore = false;
      // Keep current articles even on error
      if (!isClosed) {
        emit(ArticlesHorizontalBarCategorySuccess(_allArticles));
      }
    }
  }

  Future<void> refreshCategories() async {
    if (isClosed) return;
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
