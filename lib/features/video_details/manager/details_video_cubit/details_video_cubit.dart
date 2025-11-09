import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';
import 'package:sahifa/features/video_details/data/repo/details_video_repo.dart';

part 'details_video_state.dart';

class DetailsVideoCubit extends Cubit<DetailsVideoState> {
  DetailsVideoCubit(this._detailsVideoRepo) : super(DetailsVideoInitial());
  final DetailsVideoRepo _detailsVideoRepo;

  @override
  void emit(DetailsVideoState state) {
    if (!isClosed) {
      try {
        super.emit(state);
      } catch (_) {
        // Ignore all emit errors when closed
      }
    }
  }

  Future<void> fetchVideoDetails({
    required String videoSlug,
    required String categorySlug,
  }) async {
    if (isClosed) return;

    emit(DetailsVideoLoading());
    final result = await _detailsVideoRepo.getVideoDetails(
      videoSlug: videoSlug,
      categorySlug: categorySlug,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(DetailsVideoError(error));
      },
      (video) {
        if (!isClosed) emit(DetailsVideoLoaded(video));
      },
    );
  }
}
