import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/home/data/repo/articles_drawer_subcategory_repo.dart';

part 'articles_drawer_subcategory_state.dart';

class ArticlesDrawerSubcategoryCubit
    extends Cubit<ArticlesDrawerSubcategoryState> {
  ArticlesDrawerSubcategoryCubit(this._articlesDrawerSubcategoryRepo)
    : super(ArticlesDrawerSubcategoryInitial());

  final ArticlesDrawerSubcategoryRepo _articlesDrawerSubcategoryRepo;

  Future<void> getArticlesDrawerSubcategory({
    required String categorySlug,
    required String language,
  }) async {
    emit(ArticlesDrawerSubcategoryLoading());
    final result = await _articlesDrawerSubcategoryRepo
        .getArticlesDrawerSubcategory(
          categorySlug: categorySlug,
          language: language,
        );
    result.fold(
      (l) => emit(ArticlesDrawerSubcategoryError(l)),
      (r) => emit(ArticlesDrawerSubcategoryLoaded(r.articles ?? [])),
    );
  }
}
