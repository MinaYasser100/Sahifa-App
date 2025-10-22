import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_breaking_news_repo.dart';

part 'articles_breaking_news_state.dart';

class ArticlesBreakingNewsCubit extends Cubit<ArticlesBreakingNewsState> {
  ArticlesBreakingNewsCubit(this._articlesBreakingNewsRepo)
    : super(ArticlesBreakingNewsInitial());
  final ArticlesBreakingNewsRepo _articlesBreakingNewsRepo;

  Future<void> fetchBreakingNewsArticles(String language) async {
    emit(ArticlesBreakingNewsLoading());
    final result = await _articlesBreakingNewsRepo.getBreakingNewsArticles(
      language,
    );
    result.fold(
      (error) => emit(ArticlesBreakingNewsError(error)),
      (articlesCategoryModel) => emit(
        ArticlesBreakingNewsLoaded(articlesCategoryModel.articles ?? []),
      ),
    );
  }
}
