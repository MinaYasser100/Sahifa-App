import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/utils/debouncer.dart';
import 'package:sahifa/features/search/data/repo/search_articles_repo.dart';

part 'search_articles_state.dart';

class SearchArticlesCubit extends Cubit<SearchArticlesState> {
  SearchArticlesCubit(this._searchArticlesRepo)
    : super(SearchArticlesInitial());

  final SearchArticlesRepo _searchArticlesRepo;

  // Debouncer instance with 500ms delay
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 500),
  );

  // Request ID counter to track the latest request
  int _requestId = 0;

  // CancelToken for cancelling previous requests
  CancelToken? _cancelToken;

  /// Search articles with debouncing and request ID tracking
  /// This ensures only the latest search result is displayed
  Future<void> searchArticlesByQuery(String query, String language) async {
    if (isClosed) return;

    // Increment request ID for new search
    final currentRequestId = ++_requestId;

    log('🔍 Search initiated - Query: "$query", Request ID: $currentRequestId');

    // Cancel previous request if it exists
    _cancelToken?.cancel('New search request');
    _cancelToken = CancelToken();

    // Debounce the search to avoid excessive API calls
    _debouncer.run(() async {
      if (isClosed) return;

      // Check if this is still the latest request
      if (currentRequestId != _requestId) {
        log(
          '⏭️ Skipping outdated request ID: $currentRequestId (current: $_requestId)',
        );
        return;
      }

      emit(SearchArticlesLoadingState());

      final result = await _searchArticlesRepo.searchArticles(
        query: query,
        language: language,
        cancelToken: _cancelToken,
      );

      if (isClosed) return;

      // Double-check request ID before emitting result
      if (currentRequestId != _requestId) {
        log(
          '⏭️ Discarding outdated response for request ID: $currentRequestId (current: $_requestId)',
        );
        return;
      }

      result.fold(
        (error) {
          if (!isClosed) {
            log('❌ Search error for request ID $currentRequestId: $error');
            emit(SearchArticlesErrorState(error));
          }
        },
        (articles) {
          if (!isClosed) {
            log(
              '✅ Search success for request ID $currentRequestId: ${articles.length} articles found',
            );
            emit(SearchArticlesLoadedState(articles));
          }
        },
      );
    });
  }

  /// Reset search state to initial
  void resetSearch() {
    if (isClosed) return;
    _cancelToken?.cancel('Search reset');
    _debouncer.cancel();
    _requestId = 0;
    emit(SearchArticlesInitial());
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    _cancelToken?.cancel('Cubit closed');
    return super.close();
  }
}
