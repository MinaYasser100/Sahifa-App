import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/search_category/data/repo/articles_search_category_repo.dart';

part 'articles_search_category_state.dart';

class ArticlesSearchCategoryCubit extends Cubit<ArticlesSearchCategoryState> {
  ArticlesSearchCategoryCubit(this._articlesSearchCategoryRepo)
    : super(ArticlesSearchCategoryInitial());

  final ArticlesSearchCategoryRepo _articlesSearchCategoryRepo;

  // Pagination variables
  int _currentPage = 1;
  bool _hasMore = true;
  List<ArticleModel> _articles = [];
  String? _currentCategorySlug;
  String? _currentLanguage;

  Future<void> fetchSearchCategories({
    required String language,
    required String categorySlug,
    bool isRefresh = false,
  }) async {
    // Don't proceed if cubit is closed
    if (isClosed) return;

    // Reset on new category or language
    if (_currentCategorySlug != categorySlug ||
        _currentLanguage != language ||
        isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      _articles = [];
      _currentCategorySlug = categorySlug;
      _currentLanguage = language;
    }

    // Don't fetch if no more data
    if (!_hasMore && !isRefresh) return;

    // Show loading indicator
    if (_currentPage == 1) {
      if (!isClosed) emit(ArticlesSearchCategoryLoading());
    } else {
      if (!isClosed) emit(ArticlesSearchCategoryLoadingMore(_articles));
    }

    final result = await _articlesSearchCategoryRepo.fetchArticleSearchCategory(
      categorySlug,
      language,
      page: _currentPage,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (_currentPage == 1) {
          if (!isClosed) emit(ArticlesSearchCategoryError(error));
        } else {
          if (!isClosed) {
            emit(ArticlesSearchCategoryLoaded(_articles, hasMore: _hasMore));
          }
        }
      },
      (articlesModel) {
        final newArticles = articlesModel.articles ?? [];

        // Check if there are more pages
        final totalPages = articlesModel.totalPages ?? 1;
        _hasMore = _currentPage < totalPages;

        // Add new articles to list
        _articles.addAll(newArticles);
        _currentPage++;

        if (_articles.isEmpty) {
          if (!isClosed) emit(ArticlesSearchCategoryEmpty());
        } else {
          if (!isClosed) {
            emit(ArticlesSearchCategoryLoaded(_articles, hasMore: _hasMore));
          }
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed) return;
    if (_hasMore && _currentCategorySlug != null && _currentLanguage != null) {
      await fetchSearchCategories(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
      );
    }
  }

  Future<void> refresh() async {
    if (isClosed) return;
    _articlesSearchCategoryRepo.refresh();
    if (_currentCategorySlug != null && _currentLanguage != null) {
      await fetchSearchCategories(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
        isRefresh: true,
      );
    }
  }
}
