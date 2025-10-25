import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/tv_videos_model/tv_videos_model.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';

abstract class VideoBannerRepo {
  Future<Either<String, List<VideoModel>>> fetchVideoBanners(String language);
}

class VideoBannerRepoImpl implements VideoBannerRepo {
  // Singleton Pattern
  static final VideoBannerRepoImpl _instance = VideoBannerRepoImpl._internal();
  factory VideoBannerRepoImpl() => _instance;
  VideoBannerRepoImpl._internal();
  final DioHelper _dioHelper = DioHelper();

  // Memory Cache
  List<VideoModel>? _cachedVideoBanners;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedVideoBanners != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<VideoModel>>> fetchVideoBanners(
    String language,
  ) async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedVideoBanners != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedVideoBanners!);
      }

      // Fetch video banners from API
      final response = await _dioHelper.getData(
        url: ApiEndpoints.videos.path,
        query: {
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.language: language,
          ApiQueryParams.isSlider: true,
        },
      );

      final TvVideosModel tvVideosModel = TvVideosModel.fromJson(response.data);
      final List<VideoModel> videoBanners = tvVideosModel.videos ?? [];

      // Store in cache
      _cachedVideoBanners = videoBanners;
      _lastFetchTime = DateTime.now();

      return Right(videoBanners);
    } catch (e) {
      return Left("failed_to_load_video_banners".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedVideoBanners = null;
    _lastFetchTime = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, List<VideoModel>>> forceRefresh(String language) async {
    clearCache();
    return fetchVideoBanners(language);
  }
}
