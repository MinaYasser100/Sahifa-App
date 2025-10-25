import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/my_favorites/data/repo/my_favorite_repo.dart';

part 'my_favorite_state.dart';

class MyFavoriteCubit extends Cubit<MyFavoriteState> {
  MyFavoriteCubit(this.myFavoriteRepo) : super(MyFavoriteInitial());

  final MyFavoriteRepo myFavoriteRepo;

  /// Fetch favorites from repository
  Future<void> fetchFavorites() async {
    if (isClosed) return;

    // Only emit loading if we don't have cached data
    // This prevents showing loading spinner when data is already cached
    final repoImpl = myFavoriteRepo as MyFavoriteRepoImpl;
    if (!repoImpl.hasValidCache) {
      emit(MyFavoriteLoading());
    }

    final result = await myFavoriteRepo.fetchFavorites();

    if (isClosed) return;

    result.fold(
      (error) => emit(MyFavoriteError(error)),
      (favorites) => emit(MyFavoriteLoaded(favorites)),
    );
  }

  /// Refresh favorites (force refresh, ignoring cache)
  Future<void> refreshFavorites() async {
    if (isClosed) return;

    emit(MyFavoriteLoading());

    final repoImpl = myFavoriteRepo as MyFavoriteRepoImpl;
    final result = await repoImpl.forceRefresh();

    if (isClosed) return;

    result.fold(
      (error) => emit(MyFavoriteError(error)),
      (favorites) => emit(MyFavoriteLoaded(favorites)),
    );
  }

  /// Remove article from favorites
  Future<void> removeFavorite(String articleId) async {
    if (isClosed) return;

    final repoImpl = myFavoriteRepo as MyFavoriteRepoImpl;
    final result = await repoImpl.removeFavorite(articleId);

    if (isClosed) return;

    result.fold(
      (error) {
        // Show error but don't change state
        // You can emit a specific error state or handle it differently
      },
      (success) {
        // After removing, refresh the list
        fetchFavorites();
      },
    );
  }
}
