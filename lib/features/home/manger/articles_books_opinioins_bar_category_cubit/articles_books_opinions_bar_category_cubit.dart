import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_books_opinions_bar_category_repo.dart';

part 'articles_books_opinions_bar_category_state.dart';

class ArticlesBooksOpinionsBarCategoryCubit
    extends Cubit<ArticlesBooksOpinionsBarCategoryState> {
  ArticlesBooksOpinionsBarCategoryCubit(this._repo)
    : super(ArticlesBooksOpinionsBarCategoryInitial());

  final ArticlesBooksOpinionsBarCategoryRepo _repo;

  // Pagination state
  int _currentPage = 1;
  int? _totalPages;
  bool _isLoadingMore = false;
  final List<ArticleModel> _allArticles = [];

  // Getters
  List<ArticleModel> get articles => List.unmodifiable(_allArticles);
  bool get hasMorePages => _totalPages == null || _currentPage < _totalPages!;
  bool get isLoadingMore => _isLoadingMore;

  /// Fetch initial articles (page 1)
  Future<void> fetchArticles({required String language}) async {
    if (isClosed) return;

    emit(ArticlesBooksOpinionsBarCategoryLoading());

    final result = await _repo.fetchArticlesBooksOpinionsBarCategory(
      language: language,
      pageNumber: 1,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) {
          emit(ArticlesBooksOpinionsBarCategoryError(error));
        }
      },
      (data) {
        if (!isClosed) {
          _allArticles.clear();
          _allArticles.addAll(data.articles ?? []);
          _currentPage = data.pageNumber ?? 1;
          _totalPages = data.totalPages;

          log(
            '✅ [BooksOpinionsCubit] Loaded ${_allArticles.length} articles, page $_currentPage/$_totalPages',
          );

          emit(
            ArticlesBooksOpinionsBarCategoryLoaded(
              articles: _allArticles,
              hasMorePages: hasMorePages,
            ),
          );
        }
      },
    );
  }

  /// Load more articles (pagination)
  Future<void> loadMoreArticles({required String language}) async {
    if (isClosed || _isLoadingMore || !hasMorePages) return;

    _isLoadingMore = true;
    final nextPage = _currentPage + 1;

    log('📄 [BooksOpinionsCubit] Loading page $nextPage');

    final result = await _repo.fetchArticlesBooksOpinionsBarCategory(
      language: language,
      pageNumber: nextPage,
    );

    if (isClosed) return;

    _isLoadingMore = false;

    result.fold(
      (error) {
        log('❌ [BooksOpinionsCubit] Error loading more: $error');
        // Keep current state, just log error
      },
      (data) {
        if (!isClosed) {
          _allArticles.addAll(data.articles ?? []);
          _currentPage = data.pageNumber ?? nextPage;
          _totalPages = data.totalPages;

          log(
            '✅ [BooksOpinionsCubit] Now have ${_allArticles.length} articles, page $_currentPage/$_totalPages',
          );

          emit(
            ArticlesBooksOpinionsBarCategoryLoaded(
              articles: _allArticles,
              hasMorePages: hasMorePages,
            ),
          );
        }
      },
    );
  }

  /// Force refresh (pull to refresh)
  Future<void> refresh({required String language}) async {
    if (isClosed) return;

    log('🔄 [BooksOpinionsCubit] Refreshing...');

    // Force refresh from repo
    final repoImpl = _repo as ArticlesBooksOpinionsBarCategoryRepoImpl;
    await repoImpl.forceRefresh(language: language);

    // Reload first page
    await fetchArticles(language: language);
  }

  @override
  Future<void> close() {
    log('🔒 [BooksOpinionsCubit] Closing cubit');
    return super.close();
  }

  @override
  void emit(ArticlesBooksOpinionsBarCategoryState state) {
    if (!isClosed) {
      try {
        super.emit(state);
      } catch (e) {
        log('⚠️ [BooksOpinionsCubit] Error emitting state: $e');
      }
    }
  }
}
