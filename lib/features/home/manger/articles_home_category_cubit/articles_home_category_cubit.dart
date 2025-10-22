import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_home_category_repo.dart';

part 'articles_home_category_state.dart';

class ArticlesHomeCategoryCubit extends Cubit<ArticlesHomeCategoryState> {
  ArticlesHomeCategoryCubit(this._articlesHomeCategoryRepo)
    : super(ArticlesHomeCategoryInitial());

  final ArticlesHomeCategoryRepoImpl _articlesHomeCategoryRepo;

  void fetchArticlesHomeByCategory(String categorySlug, String language) async {
    emit(ArticlesHomeCategoryLoading());
    try {
      final result = await _articlesHomeCategoryRepo.getArticlesByCategory(
        categorySlug,
        language,
      );
      result.fold(
        (failure) {
          emit(ArticlesHomeCategoryError(failure));
        },
        (articlesData) {
          emit(ArticlesHomeCategorySuccess(articlesData.articles ?? []));
        },
      );
    } catch (e) {
      emit(ArticlesHomeCategoryError('Failed to fetch articles: $e'));
    }
  }
}
