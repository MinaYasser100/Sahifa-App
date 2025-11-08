import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/widgets/custom_banner_carouse/repo/banner_repo.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit(this.bannerRepo) : super(BannersInitial());

  final BannerRepo bannerRepo;

  /// Fetch banners from repository
  Future<void> fetchBanners(String language) async {
    if (isClosed) return;

    // Only emit loading if we don't have cached data
    // This prevents showing loading spinner when data is already cached
    final repoImpl = bannerRepo as BannerRepoImpl;
    if (!repoImpl.hasValidCache) {
      if (!isClosed) emit(BannersLoading());
    }

    final result = await bannerRepo.fetchBanners(language);

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(BannersError(error));
      },
      (banners) {
        if (!isClosed) emit(BannersLoaded(banners));
      },
    );
  }

  /// Refresh banners (force refresh, ignoring cache)
  Future<void> refreshBanners(String language) async {
    if (isClosed) return;

    if (!isClosed) emit(BannersLoading());

    final repoImpl = bannerRepo as BannerRepoImpl;
    final result = await repoImpl.forceRefresh(language);

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(BannersError(error));
      },
      (banners) {
        if (!isClosed) emit(BannersLoaded(banners));
      },
    );
  }
}
