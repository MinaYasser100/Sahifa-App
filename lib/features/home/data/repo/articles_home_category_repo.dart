import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class ArticlesHomeCategoryRepo {
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  );
}

class ArticlesHomeCategoryRepoImpl implements ArticlesHomeCategoryRepo {
  // Singleton Pattern
  static final ArticlesHomeCategoryRepoImpl _instance =
      ArticlesHomeCategoryRepoImpl._internal();
  factory ArticlesHomeCategoryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  ArticlesHomeCategoryRepoImpl._internal();

  late DioHelper _dioHelper;

  // Memory Cache - Map by categorySlug and language
  final Map<String, ArticlesCategoryModel> _cache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Generate cache key
  String _getCacheKey(String categorySlug, String language) {
    return '${categorySlug}_$language';
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
  Future<Either<String, ArticlesCategoryModel>> getArticlesByCategory(
    String categorySlug,
    String language,
  ) async {
    try {
      final cacheKey = _getCacheKey(categorySlug, language);

      // Check cache first
      if (_isCacheValid(cacheKey)) {
        return Right(_cache[cacheKey]!);
      }

      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.posts.path,
        query: {
          ApiQueryParams.categorySlug: categorySlug,
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.type: PostType.article.value,
          ApiQueryParams.includeLikedByUsers: true,
          ApiQueryParams.hasAuthor: false,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);

      // Update cache
      _cache[cacheKey] = articlesCategoryModel;
      _cacheTimestamps[cacheKey] = DateTime.now();

      return Right(articlesCategoryModel);
    } catch (e) {
      return Left('Error fetching articles');
    }
  }

  // Clear all cache
  void clearCache() {
    _cache.clear();
    _cacheTimestamps.clear();
  }
}
