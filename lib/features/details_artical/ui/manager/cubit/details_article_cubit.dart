import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/details_artical/ui/data/repo/details_article_repo.dart';

part 'details_article_state.dart';

class DetailsArticleCubit extends Cubit<DetailsArticleState> {
  DetailsArticleCubit(this._detailsArticleRepo)
    : super(DetailsArticleInitial());
  final DetailsArticleRepo _detailsArticleRepo;

  @override
  void emit(DetailsArticleState state) {
    if (!isClosed) {
      try {
        super.emit(state);
      } catch (_) {
        // Ignore all emit errors when closed
      }
    }
  }

  Future<void> fetchArticleDetails({
    required String articleSlug,
    required String categorySlug,
  }) async {
    if (isClosed) return;

    emit(DetailsArticleLoading());
    final result = await _detailsArticleRepo.getArticleDetails(
      articleSlug: articleSlug,
      categorySlug: categorySlug,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(DetailsArticleError(error));
      },
      (article) {
        if (!isClosed) emit(DetailsArticleLoaded(article));
      },
    );
  }
}
