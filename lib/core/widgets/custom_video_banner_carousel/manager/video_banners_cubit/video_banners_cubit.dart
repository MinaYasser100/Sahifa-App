import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/repo/video_banner_repo.dart';

part 'video_banners_state.dart';

class VideoBannersCubit extends Cubit<VideoBannersState> {
  VideoBannersCubit(this._videoBannerRepo) : super(VideoBannersInitial());

  final VideoBannerRepo _videoBannerRepo;

  /// Fetch video banners from repository
  Future<void> fetchVideoBanners(String language) async {
    if (isClosed) return;

    // Only emit loading if we don't have cached data
    final repoImpl = _videoBannerRepo as VideoBannerRepoImpl;
    if (!repoImpl.hasValidCache) {
      if (!isClosed) emit(VideoBannersLoading());
    }

    final result = await _videoBannerRepo.fetchVideoBanners(language);

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(VideoBannersError(error));
      },
      (videoBanners) {
        if (!isClosed) emit(VideoBannersLoaded(videoBanners));
      },
    );
  }

  /// Refresh video banners (force refresh, ignoring cache)
  Future<void> refreshVideoBanners(String language) async {
    if (isClosed) return;

    if (!isClosed) emit(VideoBannersLoading());

    final repoImpl = _videoBannerRepo as VideoBannerRepoImpl;
    final result = await repoImpl.forceRefresh(language);

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(VideoBannersError(error));
      },
      (videoBanners) {
        if (!isClosed) emit(VideoBannersLoaded(videoBanners));
      },
    );
  }
}
