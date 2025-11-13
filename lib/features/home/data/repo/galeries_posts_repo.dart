import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_cache_manager.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/articles_category_model/article_model.dart';
import 'package:sahifa/core/model/articles_category_model/articles_category_model.dart';
import 'package:sahifa/core/utils/language_helper.dart';

abstract class GaleriesPostsRepo {
  Future<Either<String, ArticlesCategoryModel>> getGaleriesPosts(
    String language, {
    int page = 1,
  });
  bool hasValidCache(int page);
  void clearCache();
  void refresh();
}

class GaleriesPostsRepoImpl implements GaleriesPostsRepo {
  // Singleton Pattern
  static final GaleriesPostsRepoImpl _instance =
      GaleriesPostsRepoImpl._internal();
  factory GaleriesPostsRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }

  GaleriesPostsRepoImpl._internal() {
    _cacheManager = GenericCacheManager<ArticleModel>(
      cacheIdentifier: 'GaleriesPosts',
    );
    _etagHandler = GenericETagHandler(handlerIdentifier: 'GaleriesPosts');
  }

  late DioHelper _dioHelper;
  late final GenericCacheManager<ArticleModel> _cacheManager;
  late final GenericETagHandler _etagHandler;

  @override
  bool hasValidCache(int page) {
    return _cacheManager.hasValidMemoryCache(page);
  }

  @override
  Future<Either<String, ArticlesCategoryModel>> getGaleriesPosts(
    String language, {
    int page = 1,
  }) async {
    try {
      // STEP 1: Handle language change
      if (_cacheManager.hasLanguageChanged(language)) {
        _cacheManager.clearAll();
      }
      _cacheManager.setCachedLanguage(language);

      // STEP 2: Check Memory Cache
      if (_cacheManager.hasValidMemoryCache(page)) {
        log('💾 Using valid memory cache for page $page');
        return _buildSuccessResponse(page);
      }

      // STEP 3: Make network request
      log('📡 Making network request for page $page');
      final response = await _makeRequest(language, page);

      _etagHandler.logResponseStatus(response, page);

      // STEP 4: Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(page);
      }

      // STEP 5: Handle 200 OK with new data
      return _handle200Response(response, page);
    } catch (e) {
      return Left('Error fetching galleries posts'.tr());
    }
  }

  Either<String, ArticlesCategoryModel> _buildSuccessResponse(int page) {
    return Right(
      ArticlesCategoryModel(
        articles: _cacheManager.getCachedData(page),
        pageNumber: page,
        totalPages: _cacheManager.getTotalPages(page),
      ),
    );
  }

  Future<Response> _makeRequest(String language, int page) async {
    final backendLanguage = LanguageHelper.convertLanguageCodeToBackend(
      language,
    );
    final etag = _cacheManager.getETag(page);
    final headers = _etagHandler.prepareHeaders(etag, page);

    return await _dioHelper.getData(
      url: ApiEndpoints.posts.path,
      query: {
        ApiQueryParams.pageSize: 30,
        ApiQueryParams.pageNumber: page,
        ApiQueryParams.language: backendLanguage,
        ApiQueryParams.type: PostType.gallery.value,
        ApiQueryParams.includeLikedByUsers: true,
      },
      headers: headers,
    );
  }

  Either<String, ArticlesCategoryModel> _handle304Response(int page) {
    log('✅ 304 Not Modified - Data unchanged for page $page');
    if (!_cacheManager.hasCachedData(page)) {
      return Left('Error fetching galleries posts'.tr());
    }
    _cacheManager.updateTimestamp(page);
    return _buildSuccessResponse(page);
  }

  Either<String, ArticlesCategoryModel> _handle200Response(
    Response response,
    int page,
  ) {
    log('📦 200 OK - Received new data for page $page');
    final etag = _etagHandler.extractETag(response, page);
    final articlesCategoryModel = ArticlesCategoryModel.fromJson(response.data);
    final articles = articlesCategoryModel.articles ?? [];

    _cacheManager.cachePageData(
      pageNumber: page,
      data: articles,
      etag: etag,
      totalPages: articlesCategoryModel.totalPages,
    );

    return Right(articlesCategoryModel);
  }

  @override
  void clearCache() {
    _cacheManager.clearAll();
  }

  @override
  void refresh() {
    clearCache();
  }
}
