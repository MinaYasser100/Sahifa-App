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
      emit(SubcategoryArticlesLoading());
    } else {
      emit(SubcategoryArticlesLoadingMore(_articles));
    }

    final result = await _subcategoryArticlesRepo.getArticlesDrawerSubcategory(
      categorySlug: categorySlug,
      language: language,
      pageNumber: _currentPage,
    );

    result.fold(
      (error) {
        if (_currentPage == 1) {
          emit(SubcategoryArticlesError(error));
        } else {
          emit(SubcategoryArticlesLoaded(_articles, hasMore: _hasMore));
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
          emit(SubcategoryArticlesEmpty());
        } else {
          emit(SubcategoryArticlesLoaded(_articles, hasMore: _hasMore));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (_hasMore && _currentCategorySlug != null && _currentLanguage != null) {
      await fetchSubcategoryArticles(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
      );
    }
  }

  Future<void> refresh() async {
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
