import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class BannerRepo {
  Future<Either<String, List<ArticleModel>>> fetchBanners(String language);
}

class BannerRepoImpl implements BannerRepo {
  // Singleton Pattern
  static final BannerRepoImpl _instance = BannerRepoImpl._internal();
  factory BannerRepoImpl() => _instance;
  BannerRepoImpl._internal();
  final DioHelper _dioHelper = DioHelper();

  // Memory Cache
  List<ArticleModel>? _cachedBanners;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Getters for cache status (needed by Cubit to check cache)
  bool get hasValidCache =>
      _cachedBanners != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  @override
  Future<Either<String, List<ArticleModel>>> fetchBanners(
    String language,
  ) async {
    try {
      // Check if cached data exists and is still fresh
      if (_cachedBanners != null &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        // Return cached data immediately
        return Right(_cachedBanners!);
      }
      // Simulate API response - في المستقبل هيبقى API call حقيقي
      // Convert language code to backend format
      final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
        language,
      );

      final response = await _dioHelper.getData(
        url: ApiEndpoints.articles.path,
        query: {
          ApiQueryParams.pageSize: 15,
          ApiQueryParams.language: backendLanguage,
          ApiQueryParams.isSlider: true,
        },
      );
      final ArticlesCategoryModel articlesCategoryModel =
          ArticlesCategoryModel.fromJson(response.data);
      final List<ArticleModel> banners = articlesCategoryModel.articles ?? [];
      // Store in cache
      _cachedBanners = banners;
      _lastFetchTime = DateTime.now();

      return Right(banners);
    } catch (e) {
      return Left("Failed to load banners".tr());
    }
  }

  // Method to clear cache if needed (e.g., on logout or refresh)
  void clearCache() {
    _cachedBanners = null;
    _lastFetchTime = null;
  }

  // Method to force refresh (ignores cache)
  Future<Either<String, List<ArticleModel>>> forceRefresh(
    String language,
  ) async {
    clearCache();
    return fetchBanners(language);
  }
}
