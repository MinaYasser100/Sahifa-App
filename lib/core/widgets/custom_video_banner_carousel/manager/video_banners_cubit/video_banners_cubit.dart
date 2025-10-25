import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/core/widgets/custom_video_banner_carousel/repo/video_banner_repo.dart';

part 'video_banners_state.dart';

class VideoBannersCubit extends Cubit<VideoBannersState> {
  VideoBannersCubit(this._videoBannerRepo) : super(VideoBannersInitial());

  final VideoBannerRepo _videoBannerRepo;

  /// Fetch video banners from repository
  Future<void> fetchVideoBanners(String language) async {
    // Only emit loading if we don't have cached data
    final repoImpl = _videoBannerRepo as VideoBannerRepoImpl;
    if (!repoImpl.hasValidCache) {
      emit(VideoBannersLoading());
    }

    final result = await _videoBannerRepo.fetchVideoBanners(language);

    result.fold(
      (error) => emit(VideoBannersError(error)),
      (videoBanners) => emit(VideoBannersLoaded(videoBanners)),
    );
  }

  /// Refresh video banners (force refresh, ignoring cache)
  Future<void> refreshVideoBanners(String language) async {
    emit(VideoBannersLoading());

    final repoImpl = _videoBannerRepo as VideoBannerRepoImpl;
    final result = await repoImpl.forceRefresh(language);

    result.fold(
      (error) => emit(VideoBannersError(error)),
      (videoBanners) => emit(VideoBannersLoaded(videoBanners)),
    );
  }
}
