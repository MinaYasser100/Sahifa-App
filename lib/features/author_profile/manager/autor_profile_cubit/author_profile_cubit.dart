import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/author_profile/data/repo/author_profile_repo.dart';

part 'author_profile_state.dart';

class AuthorProfileCubit extends Cubit<AuthorProfileState> {
  AuthorProfileCubit(this._repo) : super(AuthorProfileInitial());

  final AuthorProfileRepo _repo;

  int _currentPage = 1;
  int? _totalPages;
  bool _isLoadingMore = false;
  final List<ArticleModel> _allArticles = [];

  bool get hasMorePages => _totalPages == null || _currentPage < _totalPages!;

  /// Fetch first page of articles
  Future<void> fetchArticles({
    required String authorName,
    required String language,
  }) async {
    // Triple Protection Pattern
    if (isClosed) return;

    emit(AuthorProfileLoading());

    final result = await _repo.fetchAuthorProfile(
      authorName: authorName,
      language: language,
      pageNumber: 1,
    );

    if (isClosed) return;

    result.fold((error) => emit(AuthorProfileError(error)), (data) {
      _allArticles.clear();
      _allArticles.addAll(data.articles ?? []);
      _currentPage = data.pageNumber ?? 1;
      _totalPages = data.totalPages;

      if (!isClosed) {
        emit(
          AuthorProfileLoaded(
            articles: List.from(_allArticles),
            hasMorePages: hasMorePages,
          ),
        );
      }
    });
  }

  /// Load more articles (pagination)
  Future<void> loadMoreArticles({
    required String authorName,
    required String language,
  }) async {
    if (_isLoadingMore || !hasMorePages || isClosed) return;

    _isLoadingMore = true;

    final result = await _repo.fetchAuthorProfile(
      authorName: authorName,
      language: language,
      pageNumber: _currentPage + 1,
    );

    if (isClosed) {
      _isLoadingMore = false;
      return;
    }

    result.fold(
      (error) {
        _isLoadingMore = false;
        // Keep current state, just log error
      },
      (data) {
        _allArticles.addAll(data.articles ?? []);
        _currentPage = data.pageNumber ?? _currentPage + 1;
        _totalPages = data.totalPages;
        _isLoadingMore = false;

        if (!isClosed) {
          emit(
            AuthorProfileLoaded(
              articles: List.from(_allArticles),
              hasMorePages: hasMorePages,
            ),
          );
        }
      },
    );
  }

  /// Refresh (pull to refresh)
  Future<void> refresh({
    required String authorName,
    required String language,
  }) async {
    if (isClosed) return;

    // Force refresh in repo
    final repoImpl = _repo as AuthorProfileRepoImpl;
    await repoImpl.forceRefresh(authorName: authorName, language: language);

    // Fetch fresh data
    await fetchArticles(authorName: authorName, language: language);
  }
}
