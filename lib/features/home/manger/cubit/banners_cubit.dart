import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/article_item_model/article_item_model.dart';
import 'package:sahifa/features/home/data/repo/banner_repo.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit(this.bannerRepo) : super(BannersInitial());

  final BannerRepo bannerRepo;

  /// Fetch banners from repository
  Future<void> fetchBanners() async {
    if (isClosed) return;

    emit(BannersLoading());

    final result = await bannerRepo.fetchBanners();

    if (isClosed) return;

    result.fold(
      (error) => emit(BannersError(error)),
      (banners) => emit(BannersLoaded(banners)),
    );
  }

  /// Refresh banners
  Future<void> refreshBanners() async {
    await fetchBanners();
  }
}
