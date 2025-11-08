import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_breaking_news_repo.dart';

part 'articles_breaking_news_state.dart';

class ArticlesBreakingNewsCubit extends Cubit<ArticlesBreakingNewsState> {
  ArticlesBreakingNewsCubit(this._articlesBreakingNewsRepo)
    : super(ArticlesBreakingNewsInitial());
  final ArticlesBreakingNewsRepo _articlesBreakingNewsRepo;

  // Pagination variables
  int _currentPage = 1;
  bool _hasMore = true;
  List<ArticleModel> _articles = [];
  String _currentLanguage = '';

  Future<void> fetchBreakingNewsArticles(
    String language, {
    bool isRefresh = false,
  }) async {
    // Don't proceed if cubit is closed
    if (isClosed) return;

    // Reset if language changed or refresh
    if (_currentLanguage != language || isRefresh) {
      _currentPage = 1;
      _hasMore = true;
      _articles = [];
      _currentLanguage = language;
    }

    // Don't fetch if already loading or no more data
    if (state is ArticlesBreakingNewsLoading ||
        state is ArticlesBreakingNewsLoadingMore) {
      return;
    }

    if (!_hasMore && !isRefresh) {
      return;
    }

    // Emit appropriate loading state
    if (_articles.isEmpty) {
      if (!isClosed) emit(ArticlesBreakingNewsLoading());
    } else {
      if (!isClosed) emit(ArticlesBreakingNewsLoadingMore(_articles));
    }

    final result = await _articlesBreakingNewsRepo.getBreakingNewsArticles(
      language,
      page: _currentPage,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (_articles.isEmpty) {
          if (!isClosed) emit(ArticlesBreakingNewsError(error));
        } else {
          // Keep showing current articles even if load more fails
          if (!isClosed) emit(ArticlesBreakingNewsLoaded(_articles, _hasMore));
        }
      },
      (articlesCategoryModel) {
        final newArticles = articlesCategoryModel.articles ?? [];

        if (newArticles.isEmpty) {
          _hasMore = false;
          if (_articles.isEmpty) {
            if (!isClosed) emit(ArticlesBreakingNewsEmpty());
          } else {
            if (!isClosed) emit(ArticlesBreakingNewsLoaded(_articles, false));
          }
        } else {
          _articles.addAll(newArticles);
          _currentPage++;
          _hasMore = newArticles.length >= 30; // pageSize

          if (!isClosed) emit(ArticlesBreakingNewsLoaded(_articles, _hasMore));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed || !_hasMore || _currentLanguage.isEmpty) return;
    await fetchBreakingNewsArticles(_currentLanguage);
  }

  Future<void> refresh() async {
    if (isClosed || _currentLanguage.isEmpty) return;
    _articlesBreakingNewsRepo.refresh();
    await fetchBreakingNewsArticles(_currentLanguage, isRefresh: true);
  }
}
