import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/articals_category_section/data/repo/subcategory_articles_repo.dart';

part 'subcategory_articles_state.dart';

class SubcategoryArticlesCubit extends Cubit<SubcategoryArticlesState> {
  SubcategoryArticlesCubit(this._subcategoryArticlesRepo)
    : super(SubcategoryArticlesInitial());

  final SubcategoryArticlesRepo _subcategoryArticlesRepo;

  // Pagination variables
  int _currentPage = 1;
  bool _hasMore = true;
  List<ArticleModel> _articles = [];
  String? _currentCategorySlug;
  String? _currentLanguage;

  Future<void> fetchSubcategoryArticles({
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
      if (!isClosed) emit(SubcategoryArticlesLoading());
    } else {
      if (!isClosed) emit(SubcategoryArticlesLoadingMore(_articles));
    }

    final result = await _subcategoryArticlesRepo.getArticlesDrawerSubcategory(
      categorySlug: categorySlug,
      language: language,
      pageNumber: _currentPage,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (_currentPage == 1) {
          if (!isClosed) emit(SubcategoryArticlesError(error));
        } else {
          if (!isClosed) {
            emit(SubcategoryArticlesLoaded(_articles, hasMore: _hasMore));
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
          if (!isClosed) emit(SubcategoryArticlesEmpty());
        } else {
          if (!isClosed) {
            emit(SubcategoryArticlesLoaded(_articles, hasMore: _hasMore));
          }
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed) return;
    if (_hasMore && _currentCategorySlug != null && _currentLanguage != null) {
      await fetchSubcategoryArticles(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
      );
    }
  }

  Future<void> refresh() async {
    if (isClosed) return;
    if (_currentCategorySlug != null && _currentLanguage != null) {
      // Clear cache by calling forceRefresh from repo
      await _subcategoryArticlesRepo.forceRefresh(
        categorySlug: _currentCategorySlug!,
        language: _currentLanguage!,
      );
      await fetchSubcategoryArticles(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
        isRefresh: true,
      );
    }
  }
}
