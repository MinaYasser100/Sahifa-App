import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/features/my_favorites/data/repo/my_favorite_repo.dart';

part 'my_favorite_state.dart';

class MyFavoriteCubit extends Cubit<MyFavoriteState> {
  MyFavoriteCubit(this.myFavoriteRepo) : super(MyFavoriteInitial());

  final MyFavoriteRepo myFavoriteRepo;

  // Pagination state
  final List<ArticleModel> _allFavorites = [];
  int _currentPage = 1;
  int? _totalPages;
  bool _isFetchingMore = false;

  List<ArticleModel> get allFavorites => _allFavorites;
  int get currentPage => _currentPage;
  int? get totalPages => _totalPages;
  bool get isFetchingMore => _isFetchingMore;

  /// Fetch favorites from repository (page 1)
  Future<void> fetchFavorites() async {
    if (isClosed) return;

    emit(MyFavoriteLoading());

    final result = await myFavoriteRepo.fetchFavorites(pageNumber: 1);

    if (isClosed) return;

    result.fold((error) => emit(MyFavoriteError(error)), (favoritesModel) {
      _allFavorites.clear();
      _allFavorites.addAll(favoritesModel.articles ?? []);
      _currentPage = 1;
      _totalPages = favoritesModel.totalPages;
      emit(MyFavoriteLoaded(_allFavorites));
    });
  }

  /// Load more favorites (pagination)
  Future<void> loadMoreFavorites() async {
    if (isClosed || _isFetchingMore) return;

    // Check if there are more pages to load
    if (_totalPages != null && _currentPage >= _totalPages!) {
      return; // No more pages
    }

    _isFetchingMore = true;
    emit(MyFavoriteLoadingMore(_allFavorites)); // Emit loading more state

    final nextPage = _currentPage + 1;
    final result = await myFavoriteRepo.fetchFavorites(pageNumber: nextPage);

    if (isClosed) return;

    result.fold(
      (error) {
        _isFetchingMore = false;
        // Don't emit error, just keep current favorites
        emit(MyFavoriteLoaded(_allFavorites));
      },
      (favoritesModel) {
        _allFavorites.addAll(favoritesModel.articles ?? []);
        _currentPage = nextPage;
        _totalPages = favoritesModel.totalPages;
        _isFetchingMore = false;
        emit(MyFavoriteLoaded(_allFavorites));
      },
    );
  }

  /// Refresh favorites (force refresh, ignoring cache)
  Future<void> refreshFavorites() async {
    if (isClosed) return;

    emit(MyFavoriteLoading());

    final repoImpl = myFavoriteRepo as MyFavoriteRepoImpl;
    final result = await repoImpl.forceRefresh();

    if (isClosed) return;

    result.fold((error) => emit(MyFavoriteError(error)), (favoritesModel) {
      _allFavorites.clear();
      _allFavorites.addAll(favoritesModel.articles ?? []);
      _currentPage = 1;
      _totalPages = favoritesModel.totalPages;
      emit(MyFavoriteLoaded(_allFavorites));
    });
  }

  /// Clear cubit state (on logout)
  void clearCache() {
    _allFavorites.clear();
    _currentPage = 1;
    _totalPages = null;
    emit(MyFavoriteInitial());
  }
}
