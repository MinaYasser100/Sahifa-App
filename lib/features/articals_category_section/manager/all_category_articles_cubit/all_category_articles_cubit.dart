import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/articals_category_section/data/repo/all_category_articles_repo.dart';

part 'all_category_articles_state.dart';

class AllCategoryArticlesCubit extends Cubit<AllCategoryArticlesState> {
  AllCategoryArticlesCubit(this._allCategoryArticlesRepo)
    : super(AllCategoryArticlesInitial());

  final AllCategoryArticlesRepo _allCategoryArticlesRepo;

  // Pagination variables
  int _currentPage = 1;
  bool _hasMore = true;
  List<ArticleModel> _articles = [];
  String? _currentCategorySlug;
  String? _currentLanguage;

  Future<void> fetchAllCategoryArticles({
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
      emit(AllCategoryArticlesLoading());
    } else {
      emit(AllCategoryArticlesLoadingMore(_articles));
    }

    final result = await _allCategoryArticlesRepo.fetchArticleSearchCategory(
      categorySlug,
      language,
      page: _currentPage,
    );

    result.fold(
      (error) {
        if (_currentPage == 1) {
          emit(AllCategoryArticlesError(error));
        } else {
          emit(AllCategoryArticlesLoaded(_articles, hasMore: _hasMore));
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
          emit(AllCategoryArticlesEmpty());
        } else {
          emit(AllCategoryArticlesLoaded(_articles, hasMore: _hasMore));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (_hasMore && _currentCategorySlug != null && _currentLanguage != null) {
      await fetchAllCategoryArticles(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
      );
    }
  }

  Future<void> refresh() async {
    _allCategoryArticlesRepo.refresh();
    if (_currentCategorySlug != null && _currentLanguage != null) {
      await fetchAllCategoryArticles(
        language: _currentLanguage!,
        categorySlug: _currentCategorySlug!,
        isRefresh: true,
      );
    }
  }
}
