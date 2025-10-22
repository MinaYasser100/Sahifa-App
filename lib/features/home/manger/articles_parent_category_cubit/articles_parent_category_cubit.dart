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
    emit(ArticlesParentCategoryLoading());
    try {
      final result = await _articlesParentCategoyRepo
          .getArticlesByParentCategory(parentCategorySlug, language);
      result.fold(
        (failure) {
          emit(ArticlesParentCategoryError(failure));
        },
        (articlesData) {
          emit(ArticlesParentCategorySuccess(articlesData.articles ?? []));
        },
      );
    } catch (e) {
      emit(ArticlesParentCategoryError('An unexpected error occurred'));
    }
  }
}
