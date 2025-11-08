import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/features/tv/data/repo/tv_repo.dart';

part 'tv_state.dart';

class TvCubit extends Cubit<TvState> {
  TvCubit(this.tvRepo) : super(TvInitial());

  final TVRepo tvRepo;

  // Pagination state
  final List<VideoModel> _allVideos = [];
  int _currentPage = 1;
  int? _totalPages;
  bool _isFetchingMore = false;

  List<VideoModel> get allVideos => _allVideos;
  int get currentPage => _currentPage;
  int? get totalPages => _totalPages;
  bool get isFetchingMore => _isFetchingMore;

  /// Fetch TV videos from repository (page 1)
  Future<void> fetchVideos({required String language}) async {
    if (isClosed) return;

    // Only emit loading if we don't have cached data
    final repoImpl = tvRepo as TVRepoImpl;
    if (!repoImpl.hasValidCache(1)) {
      emit(TvLoading());
    }

    final result = await tvRepo.fetchVideos(language: language, pageNumber: 1);

    if (isClosed) return;

    result.fold((error) => emit(TvError(error)), (tvVideosModel) {
      _allVideos.clear();
      _allVideos.addAll(tvVideosModel.videos ?? []);
      _currentPage = 1;
      _totalPages = tvVideosModel.totalPages;
      emit(TvLoaded(_allVideos));
    });
  }

  /// Load more videos (pagination)
  Future<void> loadMoreVideos({required String language}) async {
    if (isClosed || _isFetchingMore) return;

    // Check if there are more pages to load
    if (_totalPages != null && _currentPage >= _totalPages!) {
      return; // No more pages
    }

    _isFetchingMore = true;
    emit(TvLoadingMore(_allVideos)); // Emit loading more state

    final nextPage = _currentPage + 1;
    final result = await tvRepo.fetchVideos(
      language: language,
      pageNumber: nextPage,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        _isFetchingMore = false;
        // Don't emit error, just keep current videos
        emit(TvLoaded(_allVideos));
      },
      (tvVideosModel) {
        _allVideos.addAll(tvVideosModel.videos ?? []);
        _currentPage = nextPage;
        _totalPages = tvVideosModel.totalPages;
        _isFetchingMore = false;
        emit(TvLoaded(_allVideos));
      },
    );
  }

  /// Refresh TV videos (force refresh, ignoring cache)
  Future<void> refreshVideos({required String language}) async {
    if (isClosed) return;

    emit(TvLoading());

    final repoImpl = tvRepo as TVRepoImpl;
    final result = await repoImpl.forceRefresh(language: language);

    if (isClosed) return;

    result.fold((error) => emit(TvError(error)), (tvVideosModel) {
      _allVideos.clear();
      _allVideos.addAll(tvVideosModel.videos ?? []);
      _currentPage = 1;
      _totalPages = tvVideosModel.totalPages;
      emit(TvLoaded(_allVideos));
    });
  }
}
