import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/features/tv/data/models/video_item_model.dart';

abstract class TVRepo {
  Future<Either<String, List<VideoItemModel>>> fetchVideos();
}

class TVRepoImpl implements TVRepo {
  // Singleton Pattern
  static final TVRepoImpl _instance = TVRepoImpl._internal();
  factory TVRepoImpl() => _instance;
  TVRepoImpl._internal();

  // Memory Cache
  List<VideoItemModel>? _cachedVideos;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getter for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedVideos != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<VideoItemModel>>> fetchVideos() async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedVideos != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedVideos!);
      }

      // If no cache or cache expired, fetch from API
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Simulate API response - في المستقبل هيبقى API call حقيقي
      // final response = await _apiService.get('/tv-videos');
      // final videos = (response.data as List)
      //     .map((json) => VideoItemModel.fromJson(json))
      //     .toList();
      // return Right(videos);

      final List<VideoItemModel> videos = VideoItemModel.getSampleVideos();

      // Store in cache
      _cachedVideos = videos;
      _lastFetchTime = DateTime.now();
      return Right(videos);
    } catch (e) {
      return Left("failed_to_load_videos".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedVideos = null;
    _lastFetchTime = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, List<VideoItemModel>>> forceRefresh() async {
    clearCache();
    return fetchVideos();
  }
}
