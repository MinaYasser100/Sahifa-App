import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/galleries_model/galleries_model.dart';
import 'package:sahifa/features/details_gallery/data/repo/details_gallery_repo.dart';

part 'details_gallery_state.dart';

class DetailsGalleryCubit extends Cubit<DetailsGalleryState> {
  final DetailsGalleryRepo _detailsGalleryRepo;

  DetailsGalleryCubit(this._detailsGalleryRepo)
    : super(DetailsGalleryInitial());

  Future<void> fetchGalleryDetails({
    required String categorySlug,
    required String gallerySlug,
  }) async {
    emit(DetailsGalleryLoading());

    final result = await _detailsGalleryRepo.fetchGalleryDetails(
      categorySlug: categorySlug,
      gallerySlug: gallerySlug,
    );

    result.fold(
      (error) {
        log('Error fetching gallery details: $error');
        emit(DetailsGalleryError(error));
      },
      (gallery) {
        log('Gallery details fetched successfully: ${gallery.title}');
        emit(DetailsGalleryLoaded(gallery));
      },
    );
  }

  void refresh({required String categorySlug, required String gallerySlug}) {
    _detailsGalleryRepo.clearCache();
    fetchGalleryDetails(categorySlug: categorySlug, gallerySlug: gallerySlug);
  }
}
