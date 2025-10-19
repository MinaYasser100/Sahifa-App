import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/core/widgets/custom_trending/repo/trending_repo.dart';

part 'trending_state.dart';

class TrendingCubit extends Cubit<TrendingState> {
  TrendingCubit(this.trendingRepo) : super(TrendingInitial());

  final TrendingRepo trendingRepo;

  /// Fetch trending articles from repository
  Future<void> fetchTrendingArticles() async {
    if (isClosed) return;

    // Only emit loading if we don't have cached data
    // This prevents showing loading spinner when data is already cached
    final repoImpl = trendingRepo as TrendingRepoImpl;
    if (!repoImpl.hasValidCache) {
      emit(TrendingLoading());
    }

    final result = await trendingRepo.fetchTrendingArticles();

    if (isClosed) return;

    result.fold(
      (error) => emit(TrendingError(error)),
      (articles) => emit(TrendingLoaded(articles)),
    );
  }

  /// Refresh trending articles (force refresh, ignoring cache)
  Future<void> refreshTrendingArticles() async {
    if (isClosed) return;

    emit(TrendingLoading());

    final repoImpl = trendingRepo as TrendingRepoImpl;
    final result = await repoImpl.forceRefresh();

    if (isClosed) return;

    result.fold(
      (error) => emit(TrendingError(error)),
      (articles) => emit(TrendingLoaded(articles)),
    );
  }
}
