import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_books_opinions_repo.dart';

part 'articles_horizontal_books_opinions_state.dart';

class ArticlesHorizontalBooksOpinionsCubit
    extends Cubit<ArticlesHorizontalBooksOpinionsState> {
  ArticlesHorizontalBooksOpinionsCubit(this._repo)
    : super(ArticlesHorizontalBooksOpinionsInitial());

  final ArticlesHorizontalBooksOpinionsRepo _repo;

  /// Fetch articles (with cache support)
  Future<void> fetchArticles({required String language}) async {
    // Triple Protection Pattern: Check if cubit is closed
    if (isClosed) return;

    emit(ArticlesHorizontalBooksOpinionsLoading());

    final result = await _repo.fetchArticlesHorizontalBooksOpinions(language);

    // Second check after async operation
    if (isClosed) return;

    result.fold((error) => emit(ArticlesHorizontalBooksOpinionsError(error)), (
      data,
    ) {
      final articles = data.articles ?? [];
      // Third check before final emit
      if (!isClosed) {
        emit(ArticlesHorizontalBooksOpinionsLoaded(articles: articles));
      }
    });
  }

  /// Force refresh (invalidates cache)
  Future<void> refresh({required String language}) async {
    if (isClosed) return;

    // Cast to implementation to access forceRefresh
    final repoImpl = _repo as ArticlesHorizontalBooksOpinionsRepoImpl;
    await repoImpl.forceRefresh(language: language);
    await fetchArticles(language: language);
  }
}
