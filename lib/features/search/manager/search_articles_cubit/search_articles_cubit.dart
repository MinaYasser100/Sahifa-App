import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/search/data/repo/search_articles_repo.dart';

part 'search_articles_state.dart';

class SearchArticlesCubit extends Cubit<SearchArticlesState> {
  SearchArticlesCubit(this._searchArticlesRepo)
    : super(SearchArticlesInitial());
  final SearchArticlesRepo _searchArticlesRepo;
  Future<void> searchArticlesByQuery(String query, String language) async {
    if (isClosed) return;
    
    emit(SearchArticlesLoadingState());
    final result = await _searchArticlesRepo.searchArticles(
      query: query,
      language: language,
    );
    
    if (isClosed) return;
    
    result.fold(
      (error) {
        if (!isClosed) emit(SearchArticlesErrorState(error));
      },
      (articles) {
        if (!isClosed) emit(SearchArticlesLoadedState(articles));
      },
    );
  }
}
