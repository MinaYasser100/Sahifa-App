import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/galeries_posts_repo.dart';

part 'galeries_posts_state.dart';

class GaleriesPostsCubit extends Cubit<GaleriesPostsState> {
  GaleriesPostsCubit(this._galeriesPostsRepo) : super(GaleriesPostsInitial());
  final GaleriesPostsRepo _galeriesPostsRepo;

  // Pagination variables
  int _currentPage = 1;
  bool _hasMore = true;
  List<ArticleModel> _articles = [];
  String _currentLanguage = '';

  Future<void> fetchGaleriesPosts(
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
    if (state is GaleriesPostsLoading || state is GaleriesPostsLoadingMore) {
      return;
    }

    if (!_hasMore && !isRefresh) {
      return;
    }

    // Emit appropriate loading state
    if (_articles.isEmpty) {
      if (!isClosed) emit(GaleriesPostsLoading());
    } else {
      if (!isClosed) emit(GaleriesPostsLoadingMore(_articles));
    }

    final result = await _galeriesPostsRepo.getGaleriesPosts(
      language,
      page: _currentPage,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (_articles.isEmpty) {
          if (!isClosed) emit(GaleriesPostsError(error));
        } else {
          // Keep showing current articles even if load more fails
          if (!isClosed) emit(GaleriesPostsLoaded(_articles, _hasMore));
        }
      },
      (articlesCategoryModel) {
        final newArticles = articlesCategoryModel.articles ?? [];

        if (newArticles.isEmpty) {
          _hasMore = false;
          if (_articles.isEmpty) {
            if (!isClosed) emit(GaleriesPostsEmpty());
          } else {
            if (!isClosed) emit(GaleriesPostsLoaded(_articles, false));
          }
        } else {
          _articles.addAll(newArticles);
          _currentPage++;
          _hasMore = newArticles.length >= 30; // pageSize

          if (!isClosed) emit(GaleriesPostsLoaded(_articles, _hasMore));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed || !_hasMore || _currentLanguage.isEmpty) return;
    await fetchGaleriesPosts(_currentLanguage);
  }

  Future<void> refresh() async {
    if (isClosed || _currentLanguage.isEmpty) return;
    _galeriesPostsRepo.refresh();
    await fetchGaleriesPosts(_currentLanguage, isRefresh: true);
  }
}
