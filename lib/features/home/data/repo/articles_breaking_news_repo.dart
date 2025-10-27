import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesBreakingNewsRepo {
  Future<Either<String, ArticlesCategoryModel>> getBreakingNewsArticles(
    String language, {
    int page = 1,
  });
  void clearCache();
  void refresh();
}

class ArticlesBreakingNewsRepoImpl implements ArticlesBreakingNewsRepo {
  // Singleton Pattern
  static final ArticlesBreakingNewsRepoImpl _instance =
      ArticlesBreakingNewsRepoImpl._internal();
  factory ArticlesBreakingNewsRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  ArticlesBreakingNewsRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache - Map by language and page
  final Map<String, ArticlesCategoryModel> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Generate cache key
  String _getCacheKey(String language, int page) {
    return '${language}_page$page';
  }

  // Check if cache is valid
  bool _isCacheValid(String cacheKey) {
    if (!_cache.containsKey(cacheKey) ||
        !_cacheTimestamps.containsKey(cacheKey)) {
      return false;
    }
    final timestamp = _cacheTimestamps[cacheKey]!;
    return DateTime.now().difference(timestamp) < _cacheDuration;
  }

  @override
  Future<Either<String, ArticlesCategoryModel>> getBreakingNewsArticles(
    String language, {
    int page = 1,
  }) async {
    try {
      final cacheKey = _getCacheKey(language, page);

      // Check cache first
      if (_isCacheValid(cacheKey)) {
        return Right(_cache[cacheKey]!);
      }

      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.pageSize: 30,
          ApiQueryParams.pageNumber: page,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.isBreaking: true,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);

      // Update cache
      _cache[cacheKey] = articlesCategoryModel;
      _cacheTimestamps[cacheKey] = DateTime.now();

      return Right(articlesCategoryModel);
    } catch (e) {
      return Left('Error fetching breaking news articles'.tr());
    }
  }

  @override
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }

  @override
  void refresh() {
    clearCache();
  }
}
