import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/details_artical/ui/data/repo/details_article_repo.dart';

part 'details_article_state.dart';

class DetailsArticleCubit extends Cubit<DetailsArticleState> {
  DetailsArticleCubit(this._detailsArticleRepo)
    : super(DetailsArticleInitial());
  final DetailsArticleRepo _detailsArticleRepo;

  Future<void> fetchArticleDetails({
    required String articleSlug,
    required String categorySlug,
  }) async {
    emit(DetailsArticleLoading());
    final result = await _detailsArticleRepo.getArticleDetails(
      articleSlug: articleSlug,
      categorySlug: categorySlug,
    );
    result.fold(
      (error) => emit(DetailsArticleError(error)),
      (article) => emit(DetailsArticleLoaded(article)),
    );
  }
}
