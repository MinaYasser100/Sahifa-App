import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/tv_videos_model/tv_videos_model.dart';
import 'package:sahifa/core/model/tv_videos_model/video_model.dart';

abstract class TVRepo {
  Future<Either<String, TvVideosModel>> fetchVideos({
    required String language,
    required int pageNumber,
  });
}

class TVRepoImpl implements TVRepo {
  // Singleton Pattern
  static final TVRepoImpl _instance = TVRepoImpl._internal(DioHelper());
  factory TVRepoImpl() => _instance;
  TVRepoImpl._internal(this._dioHelper);
  final DioHelper _dioHelper;

  // Memory Cache - now caching per page
  final Map<int, List<VideoModel>> _cachedVideosByPage = {};
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);
  String? _cachedLanguage;

  // Getter for cache status (needed by Cubit to check cache)
  bool hasValidCache(int pageNumber) =>
      _cachedVideosByPage.containsKey(pageNumber) &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, TvVideosModel>> fetchVideos({
    required String language,
    required int pageNumber,
  }) async {
    try {
      // Clear cache if language changed
      if (_cachedLanguage != null && _cachedLanguage != language) {
        clearCache();
      }
      _cachedLanguage = language;

      // Check if cached data exists for this page and is still fresh
      if (hasValidCache(pageNumber)) {
        // Return cached data immediately
        return Right(
          TvVideosModel(
            videos: _cachedVideosByPage[pageNumber],
            pageNumber: pageNumber,
          ),
        );
      }

      final response = await _dioHelper.getData(
        url: ApiEndpoints.videos.path,
        query: {
          ApiQueryParams.pageSize: 20,
          ApiQueryParams.pageNumber: pageNumber,
          ApiQueryParams.language: language,
        },
      );

      final TvVideosModel tvVideosModel = TvVideosModel.fromJson(response.data);
      final List<VideoModel> videos = tvVideosModel.videos ?? [];

      // Store in cache by page number
      _cachedVideosByPage[pageNumber] = videos;
      _lastFetchTime = DateTime.now();

      return Right(tvVideosModel);
    } catch (e) {
      return Left("failed_to_load_videos".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedVideosByPage.clear();
    _lastFetchTime = null;
    _cachedLanguage = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, TvVideosModel>> forceRefresh({
    required String language,
  }) async {
    clearCache();
    return fetchVideos(language: language, pageNumber: 1);
  }
}
