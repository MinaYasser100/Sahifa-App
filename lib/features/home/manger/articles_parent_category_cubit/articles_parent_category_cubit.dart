import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_parent_categoy_repo.dart';

part 'articles_parent_category_state.dart';

class ArticlesParentCategoryCubit extends Cubit<ArticlesParentCategoryState> {
  ArticlesParentCategoryCubit(this._articlesParentCategoyRepo)
    : super(ArticlesParentCategoryInitial());
  final ArticlesParentCategoyRepo _articlesParentCategoyRepo;

  Future<void> fetchArticlesByParentCategory(
    String parentCategorySlug,
    String language,
  ) async {
    if (isClosed) return;

    if (!isClosed) emit(ArticlesParentCategoryLoading());
    try {
      final result = await _articlesParentCategoyRepo
          .getArticlesByParentCategory(parentCategorySlug, language);

      if (isClosed) return;

      result.fold(
        (failure) {
          if (!isClosed) emit(ArticlesParentCategoryError(failure));
        },
        (articlesData) {
          if (!isClosed) {
            emit(ArticlesParentCategorySuccess(articlesData.articles ?? []));
          }
        },
      );
    } catch (e) {
      if (!isClosed) {
        emit(ArticlesParentCategoryError('An unexpected error occurred'));
      }
    }
  }
}
