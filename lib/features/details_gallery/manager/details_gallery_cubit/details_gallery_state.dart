part of 'details_gallery_cubit.dart';

sealed class DetailsGalleryState {}

final class DetailsGalleryInitial extends DetailsGalleryState {}

final class DetailsGalleryLoading extends DetailsGalleryState {}

final class DetailsGalleryLoaded extends DetailsGalleryState {
  final GalleriesModel gallery;

  DetailsGalleryLoaded(this.gallery);
}

final class DetailsGalleryError extends DetailsGalleryState {
  final String message;

  DetailsGalleryError(this.message);
}
