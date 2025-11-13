import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sahifa/core/cache/generic_cache_manager.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/magazine_model.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';

abstract class MagazinesRepo {
  Future<Either<String, MagazineModel>> getMagazines({required int pageNumber});
  Future<Either<String, MagazineModel>> searchMagazinesByRangeDate({
    required String fromDate,
    required String toDate,
    required int pageNumber,
  });
  bool hasValidCache(int pageNumber);
  bool hasValidFilteredCache(String fromDate, String toDate, int pageNumber);
  void clearCache();
}

class MagazinesRepoImpl implements MagazinesRepo {
  // Singleton Pattern
  static final MagazinesRepoImpl _instance = MagazinesRepoImpl._internal();
  factory MagazinesRepoImpl() => _instance;

  MagazinesRepoImpl._internal() {
    _regularCacheManager = GenericCacheManager<PdfModel>(
      cacheIdentifier: 'Magazines_Regular',
    );
    _regularEtagHandler = GenericETagHandler(
      handlerIdentifier: 'Magazines_Regular',
    );
    _filteredEtagHandler = GenericETagHandler(
      handlerIdentifier: 'Magazines_Filtered',
    );
  }

  // DioHelper instance
  final DioHelper _dioHelper = DioHelper();

  // Cache managers
  late final GenericCacheManager<PdfModel> _regularCacheManager;
  late final GenericETagHandler _regularEtagHandler;
  late final GenericETagHandler _filteredEtagHandler;

  // Separate cache manager for each date range filter
  final Map<String, GenericCacheManager<PdfModel>> _filteredCacheManagers = {};

  // Get cache manager for specific filter
  GenericCacheManager<PdfModel> _getFilteredCacheManager(
    String fromDate,
    String toDate,
  ) {
    final key = '${fromDate}_$toDate';
    if (!_filteredCacheManagers.containsKey(key)) {
      _filteredCacheManagers[key] = GenericCacheManager<PdfModel>(
        cacheIdentifier: 'Magazines_Filtered_$key',
      );
    }
    return _filteredCacheManagers[key]!;
  }

  @override
  bool hasValidCache(int pageNumber) {
    return _regularCacheManager.hasValidMemoryCache(pageNumber);
  }

  @override
  bool hasValidFilteredCache(String fromDate, String toDate, int pageNumber) {
    final cacheManager = _getFilteredCacheManager(fromDate, toDate);
    return cacheManager.hasValidMemoryCache(pageNumber);
  }

  // Clear all caches
  @override
  void clearCache() {
    _regularCacheManager.clearAll();
    for (final manager in _filteredCacheManagers.values) {
      manager.clearAll();
    }
    _filteredCacheManagers.clear();
  }

  @override
  Future<Either<String, MagazineModel>> getMagazines({
    required int pageNumber,
  }) async {
    try {
      // STEP 1: Check Memory Cache
      if (_regularCacheManager.hasValidMemoryCache(pageNumber)) {
        log('💾 Using valid memory cache for magazines page $pageNumber');
        return _buildRegularSuccessResponse(pageNumber);
      }

      // STEP 2: Make network request
      log('📡 Making network request for magazines page $pageNumber');
      final response = await _makeRegularRequest(pageNumber);

      _regularEtagHandler.logResponseStatus(response, pageNumber);

      // STEP 3: Handle 304 Not Modified
      if (_regularEtagHandler.isNotModified(response)) {
        return _handleRegular304Response(pageNumber);
      }

      // STEP 4: Handle 200 OK with new data
      return _handleRegular200Response(response, pageNumber);
    } catch (e) {
      log('Error fetching magazines: $e');
      return Left('Failed to fetch magazines');
    }
  }

  Either<String, MagazineModel> _buildRegularSuccessResponse(int pageNumber) {
    return Right(
      MagazineModel(
        items: _regularCacheManager.getCachedData(pageNumber),
        pageNumber: pageNumber,
        totalPages: _regularCacheManager.getTotalPages(pageNumber),
      ),
    );
  }

  Future<Response> _makeRegularRequest(int pageNumber) async {
    final etag = _regularCacheManager.getETag(pageNumber);
    final headers = _regularEtagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.magazines.path,
      query: {'pageNumber': pageNumber, 'pageSize': 30},
      headers: headers,
    );
  }

  Either<String, MagazineModel> _handleRegular304Response(int pageNumber) {
    log('✅ 304 Not Modified - Magazines data unchanged for page $pageNumber');
    if (!_regularCacheManager.hasCachedData(pageNumber)) {
      return Left('Failed to fetch magazines');
    }
    _regularCacheManager.updateTimestamp(pageNumber);
    return _buildRegularSuccessResponse(pageNumber);
  }

  Either<String, MagazineModel> _handleRegular200Response(
    Response response,
    int pageNumber,
  ) {
    log('📦 200 OK - Received new magazines data for page $pageNumber');
    final etag = _regularEtagHandler.extractETag(response, pageNumber);

    // Ensure response.data is a Map
    final jsonData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : throw Exception(
            'Invalid response format: expected Map but got ${response.data.runtimeType}',
          );

    final MagazineModel magazineModel = MagazineModel.fromJson(jsonData);
    final items = magazineModel.items ?? [];

    _regularCacheManager.cachePageData(
      pageNumber: pageNumber,
      data: items,
      etag: etag,
      totalPages: magazineModel.totalPages,
    );

    return Right(magazineModel);
  }

  @override
  Future<Either<String, MagazineModel>> searchMagazinesByRangeDate({
    required String fromDate,
    required String toDate,
    required int pageNumber,
  }) async {
    try {
      final cacheManager = _getFilteredCacheManager(fromDate, toDate);

      // STEP 1: Check Memory Cache
      if (cacheManager.hasValidMemoryCache(pageNumber)) {
        log(
          '💾 Using valid cache for filtered magazines (${fromDate}_$toDate) page $pageNumber',
        );
        return _buildFilteredSuccessResponse(cacheManager, pageNumber);
      }

      // STEP 2: Make network request
      log(
        '📡 Fetching filtered magazines: from=$fromDate, to=$toDate, page=$pageNumber',
      );
      final response = await _makeFilteredRequest(
        fromDate,
        toDate,
        pageNumber,
        cacheManager,
      );

      _filteredEtagHandler.logResponseStatus(response, pageNumber);

      // STEP 3: Handle 304 Not Modified
      if (_filteredEtagHandler.isNotModified(response)) {
        return _handleFiltered304Response(cacheManager, pageNumber);
      }

      // STEP 4: Handle 200 OK with new data
      return _handleFiltered200Response(response, cacheManager, pageNumber);
    } catch (e) {
      log('Error searching magazines: $e');
      return Left('Failed to search magazines');
    }
  }

  Either<String, MagazineModel> _buildFilteredSuccessResponse(
    GenericCacheManager<PdfModel> cacheManager,
    int pageNumber,
  ) {
    return Right(
      MagazineModel(
        items: cacheManager.getCachedData(pageNumber),
        pageNumber: pageNumber,
        totalPages: cacheManager.getTotalPages(pageNumber),
      ),
    );
  }

  Future<Response> _makeFilteredRequest(
    String fromDate,
    String toDate,
    int pageNumber,
    GenericCacheManager<PdfModel> cacheManager,
  ) async {
    final etag = cacheManager.getETag(pageNumber);
    final headers = _filteredEtagHandler.prepareHeaders(etag, pageNumber);

    return await _dioHelper.getData(
      url: ApiEndpoints.magazines.path,
      query: {
        'from': fromDate,
        'to': toDate,
        'pageNumber': pageNumber,
        'pageSize': 30,
      },
      headers: headers,
    );
  }

  Either<String, MagazineModel> _handleFiltered304Response(
    GenericCacheManager<PdfModel> cacheManager,
    int pageNumber,
  ) {
    log(
      '✅ 304 Not Modified - Filtered magazines data unchanged for page $pageNumber',
    );
    if (!cacheManager.hasCachedData(pageNumber)) {
      return Left('Failed to search magazines');
    }
    cacheManager.updateTimestamp(pageNumber);
    return _buildFilteredSuccessResponse(cacheManager, pageNumber);
  }

  Either<String, MagazineModel> _handleFiltered200Response(
    Response response,
    GenericCacheManager<PdfModel> cacheManager,
    int pageNumber,
  ) {
    log(
      '📦 200 OK - Received new filtered magazines data for page $pageNumber',
    );
    final etag = _filteredEtagHandler.extractETag(response, pageNumber);

    // Ensure response.data is a Map
    final jsonData = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : throw Exception(
            'Invalid response format: expected Map but got ${response.data.runtimeType}',
          );

    final MagazineModel magazineModel = MagazineModel.fromJson(jsonData);
    final items = magazineModel.items ?? [];

    cacheManager.cachePageData(
      pageNumber: pageNumber,
      data: items,
      etag: etag,
      totalPages: magazineModel.totalPages,
    );

    return Right(magazineModel);
  }
}
