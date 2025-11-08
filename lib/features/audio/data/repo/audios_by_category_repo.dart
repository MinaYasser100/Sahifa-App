import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/audios_model/audios_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class AudiosByCategoryRepo {
  Future<Either<String, AudiosModel>> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
    int page = 1,
    int pageSize = 30,
  });
}

class AudiosByCategoryRepoImpl implements AudiosByCategoryRepo {
  // Singleton Pattern
  static final AudiosByCategoryRepoImpl _instance =
      AudiosByCategoryRepoImpl._internal();
  factory AudiosByCategoryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  AudiosByCategoryRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache - Map of categorySlug+language to cached data
  final Map<String, List<AudiosModel>> _cache = {};
  final Map<String, DateTime> _cacheTime = {};
  final Duration _cacheDuration = const Duration(minutes: 30);

  String _getCacheKey(String categorySlug, String language) {
    return '${categorySlug}_$language';
  }

  bool _hasValidCache(String categorySlug, String language) {
    final key = _getCacheKey(categorySlug, language);
    return _cache.containsKey(key) &&
        _cacheTime.containsKey(key) &&
        DateTime.now().difference(_cacheTime[key]!) < _cacheDuration;
  }

  @override
  Future<Either<String, AudiosModel>> fetchAudiosByCategory({
    required String categorySlug,
    required String language,
    int page = 1,
    int pageSize = 30,
  }) async {
    try {
      final key = _getCacheKey(categorySlug, language);

      // Check cache for this page
      if (_hasValidCache(categorySlug, language) &&
          _cache[key]!.length >= page &&
          page > 0) {
        // Return cached page
        return Right(_cache[key]![page - 1]);
      }

      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );
      final response = await _dioHelper.getData(
        url: ApiEndpoints.audiosByCategory.path,
        query: {
          ApiQueryParams.categorySlug: categorySlug,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.pageNumber: page,
          ApiQueryParams.pageSize: pageSize,
        },
      );

      final AudiosModel audiosModel = AudiosModel.fromJson(response.data);

      // Update cache
      if (!_cache.containsKey(key)) {
        _cache[key] = [];
      }

      // Ensure cache list is long enough
      while (_cache[key]!.length < page) {
        _cache[key]!.add(AudiosModel(audios: []));
      }

      _cache[key]![page - 1] = audiosModel;
      _cacheTime[key] = DateTime.now();

      return Right(audiosModel);
    } catch (e) {
      return Left("Error fetching audios".tr());
    }
  }

  // Force refresh - clears cache for specific category
  Future<Either<String, AudiosModel>> forceRefresh({
    required String categorySlug,
    required String language,
    int page = 1,
    int pageSize = 30,
  }) async {
    clearCache(categorySlug, language);
    return await fetchAudiosByCategory(
      categorySlug: categorySlug,
      language: language,
      page: page,
      pageSize: pageSize,
    );
  }

  // Clear cache for specific category
  void clearCache(String categorySlug, String language) {
    final key = _getCacheKey(categorySlug, language);
    _cache.remove(key);
    _cacheTime.remove(key);
  }

  // Clear all cache
  void clearAllCache() {
    _cache.clear();
    _cacheTime.clear();
  }
}
