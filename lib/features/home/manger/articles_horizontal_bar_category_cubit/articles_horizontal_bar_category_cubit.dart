import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_horizontal_bar_category.dart';

part 'articles_horizontal_bar_category_state.dart';

class ArticlesHorizontalBarCategoryCubit
    extends Cubit<ArticlesHorizontalBarCategoryState> {
  ArticlesHorizontalBarCategoryCubit(this._articlesHorizontalBarCategoryRepo)
    : super(ArticlesHorizontalBarCategoryInitial());

  final ArticlesHorizontalBarCategoryRepo _articlesHorizontalBarCategoryRepo;

  Future<void> fetchCategories({
    required String categorySlug,
    required String language,
  }) async {
    emit(ArticlesHorizontalBarCategoryLoading());
    try {
      final result = await _articlesHorizontalBarCategoryRepo
          .getArticlesByCategory(categorySlug, language);
      result.fold(
        (failure) {
          emit(ArticlesHorizontalBarCategoryError(failure));
        },
        (articlesData) {
          emit(
            ArticlesHorizontalBarCategorySuccess(articlesData.articles ?? []),
          );
        },
      );
    } catch (e) {
      emit(
        ArticlesHorizontalBarCategoryError('Failed to fetch categories: $e'),
      );
    }
  }
}
