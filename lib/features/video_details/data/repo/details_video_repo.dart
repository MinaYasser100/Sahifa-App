import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';

abstract class DetailsVideoRepo {
  Future<Either<String, VideoModel>> getVideoDetails({
    required String videoSlug,
    required String categorySlug,
  });
}

class DetailsVideoRepoImpl implements DetailsVideoRepo {
  final DioHelper _dioHelper;
  DetailsVideoRepoImpl(this._dioHelper);

  @override
  Future<Either<String, VideoModel>> getVideoDetails({
    required String videoSlug,
    required String categorySlug,
  }) async {
    try {
      // Replace path parameters
      final url = ApiEndpoints.video.withParams({
        'categorySlug': categorySlug,
        'slug': videoSlug,
      });

      final response = await _dioHelper.getData(url: url);

      // Check if response.data is directly the video object or wrapped in 'data'
      final videoData =
          response.data is Map<String, dynamic> &&
              response.data.containsKey('data')
          ? response.data['data']
          : response.data;

      final VideoModel videoModel = VideoModel.fromJson(videoData);
      return Right(videoModel);
    } catch (e) {
      log("Error fetching video details: $e");
      return Left("Error fetching video details".tr());
    }
  }
}
