import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_drawer_subcategory_repo.dart';

part 'articles_drawer_subcategory_state.dart';

class ArticlesDrawerSubcategoryCubit
    extends Cubit<ArticlesDrawerSubcategoryState> {
  ArticlesDrawerSubcategoryCubit(this._articlesDrawerSubcategoryRepo)
    : super(ArticlesDrawerSubcategoryInitial());

  final ArticlesDrawerSubcategoryRepo _articlesDrawerSubcategoryRepo;

  List<ArticleModel> _allArticles = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  /// Fetch initial articles (page 1)
  Future<void> fetchArticles({
    required String categorySlug,
    required String language,
  }) async {
    if (isClosed) return;

    // Only emit loading if no valid cache
    final repoImpl =
        _articlesDrawerSubcategoryRepo as ArticlesDrawerSubcategoryRepoImpl;
    if (!repoImpl.hasValidCache) {
      if (!isClosed) emit(ArticlesDrawerSubcategoryLoading());
    }

    final result = await _articlesDrawerSubcategoryRepo
        .getArticlesDrawerSubcategory(
          categorySlug: categorySlug,
          language: language,
          pageNumber: 1,
        );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(ArticlesDrawerSubcategoryError(error));
      },
      (articlesCategoryModel) {
        _allArticles = articlesCategoryModel.articles ?? [];
        _currentPage = articlesCategoryModel.pageNumber ?? 1;
        _totalPages = articlesCategoryModel.totalPages ?? 1;

        if (!isClosed) {
          emit(
            ArticlesDrawerSubcategoryLoaded(
              articles: _allArticles,
              currentPage: _currentPage,
              totalPages: _totalPages,
              hasMore: _currentPage < _totalPages,
            ),
          );
        }
      },
    );
  }

  /// Load more articles (pagination)
  Future<void> loadMoreArticles({
    required String categorySlug,
    required String language,
  }) async {
    if (isClosed || _isFetchingMore || _currentPage >= _totalPages) return;

    _isFetchingMore = true;

    // Emit loading more state with current articles
    if (!isClosed) {
      emit(
        ArticlesDrawerSubcategoryLoadingMore(
          articles: _allArticles,
          currentPage: _currentPage,
        ),
      );
    }

    final nextPage = _currentPage + 1;

    final result = await _articlesDrawerSubcategoryRepo
        .getArticlesDrawerSubcategory(
          categorySlug: categorySlug,
          language: language,
          pageNumber: nextPage,
        );

    if (isClosed) {
      _isFetchingMore = false;
      return;
    }

    result.fold(
      (error) {
        _isFetchingMore = false;
        // Keep current state, just show error in snackbar or something
        if (!isClosed) {
          emit(
            ArticlesDrawerSubcategoryLoaded(
              articles: _allArticles,
              currentPage: _currentPage,
              totalPages: _totalPages,
              hasMore: _currentPage < _totalPages,
            ),
          );
        }
      },
      (articlesCategoryModel) {
        _allArticles.addAll(articlesCategoryModel.articles ?? []);
        _currentPage = articlesCategoryModel.pageNumber ?? _currentPage;
        _totalPages = articlesCategoryModel.totalPages ?? _totalPages;
        _isFetchingMore = false;

        if (!isClosed) {
          emit(
            ArticlesDrawerSubcategoryLoaded(
              articles: _allArticles,
              currentPage: _currentPage,
              totalPages: _totalPages,
              hasMore: _currentPage < _totalPages,
            ),
          );
        }
      },
    );
  }

  /// Refresh articles (force refresh, ignoring cache)
  Future<void> refreshArticles({
    required String categorySlug,
    required String language,
  }) async {
    if (isClosed) return;

    if (!isClosed) emit(ArticlesDrawerSubcategoryLoading());

    final repoImpl =
        _articlesDrawerSubcategoryRepo as ArticlesDrawerSubcategoryRepoImpl;
    final result = await repoImpl.forceRefresh(
      categorySlug: categorySlug,
      language: language,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(ArticlesDrawerSubcategoryError(error));
      },
      (articlesCategoryModel) {
        _allArticles = articlesCategoryModel.articles ?? [];
        _currentPage = articlesCategoryModel.pageNumber ?? 1;
        _totalPages = articlesCategoryModel.totalPages ?? 1;

        if (!isClosed) {
          emit(
            ArticlesDrawerSubcategoryLoaded(
              articles: _allArticles,
              currentPage: _currentPage,
              totalPages: _totalPages,
              hasMore: _currentPage < _totalPages,
            ),
          );
        }
      },
    );
  }
}
