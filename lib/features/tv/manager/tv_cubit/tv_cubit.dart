import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sahifa/features/tv/data/models/video_item_model.dart';
import 'package:sahifa/features/tv/data/repo/tv_repo.dart';

part 'tv_state.dart';

class TvCubit extends Cubit<TvState> {
  TvCubit(this.tvRepo) : super(TvInitial());

  final TVRepo tvRepo;

  /// Fetch TV videos from repository
  Future<void> fetchVideos() async {
    if (isClosed) return;

    // Only emit loading if we don't have cached data
    // This prevents showing loading spinner when data is already cached
    final repoImpl = tvRepo as TVRepoImpl;
    if (!repoImpl.hasValidCache) {
      emit(TvLoading());
    }

    final result = await tvRepo.fetchVideos();

    if (isClosed) return;

    result.fold(
      (error) => emit(TvError(error)),
      (videos) => emit(TvLoaded(videos)),
    );
  }

  /// Refresh TV videos (force refresh, ignoring cache)
  Future<void> refreshVideos() async {
    if (isClosed) return;

    emit(TvLoading());

    final repoImpl = tvRepo as TVRepoImpl;
    final result = await repoImpl.forceRefresh();

    if (isClosed) return;

    result.fold(
      (error) => emit(TvError(error)),
      (videos) => emit(TvLoaded(videos)),
    );
  }
}
