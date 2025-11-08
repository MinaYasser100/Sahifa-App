import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/magazine_model.dart';

abstract class MagazinesRepo {
  Future<Either<String, MagazineModel>> getMagazines({required int pageNumber});
  Future<Either<String, MagazineModel>> searchMagazinesByRangeDate({
    required String fromDate,
    required String toDate,
    required int pageNumber,
  });
  void clearCache();
  bool get hasValidCache;
}

class MagazinesRepoImpl implements MagazinesRepo {
  // Singleton Pattern
  static final MagazinesRepoImpl _instance = MagazinesRepoImpl._internal();
  factory MagazinesRepoImpl() => _instance;
  MagazinesRepoImpl._internal();

  // DioHelper instance
  final DioHelper _dioHelper = DioHelper();

  // Memory Cache for regular magazines
  Map<int, MagazineModel>? _cachedMagazines;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 30);

  // Memory Cache for filtered magazines (by date range)
  Map<String, MagazineModel>? _cachedFilteredMagazines;
  DateTime? _lastFilteredFetchTime;

  // Getter for cache status
  @override
  bool get hasValidCache =>
      _cachedMagazines != null &&
      _lastFetchTime != null &&
      DateTime.now().difference(_lastFetchTime!) < _cacheDuration;

  bool get hasValidFilteredCache =>
      _cachedFilteredMagazines != null &&
      _lastFilteredFetchTime != null &&
      DateTime.now().difference(_lastFilteredFetchTime!) < _cacheDuration;

  // Clear all caches
  @override
  void clearCache() {
    _cachedMagazines = null;
    _lastFetchTime = null;
    _cachedFilteredMagazines = null;
    _lastFilteredFetchTime = null;
  }

  @override
  Future<Either<String, MagazineModel>> getMagazines({
    required int pageNumber,
  }) async {
    try {
      // Check if cached data exists for this page
      if (_cachedMagazines != null &&
          _cachedMagazines!.containsKey(pageNumber) &&
          _lastFetchTime != null &&
          DateTime.now().difference(_lastFetchTime!) < _cacheDuration) {
        log('Returning cached magazines for page $pageNumber');
        return Right(_cachedMagazines![pageNumber]!);
      }

      log('Fetching magazines from API for page $pageNumber');
      // Fetch from API
      final response = await _dioHelper.getData(
        url: ApiEndpoints.magazines.path,
        query: {'pageNumber': pageNumber, 'pageSize': 30},
      );

      // Ensure response.data is a Map
      final jsonData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : throw Exception(
              'Invalid response format: expected Map but got ${response.data.runtimeType}',
            );

      final MagazineModel magazineModel = MagazineModel.fromJson(jsonData);

      // Cache the result
      _cachedMagazines ??= {};
      _cachedMagazines![pageNumber] = magazineModel;
      _lastFetchTime = DateTime.now();

      return Right(magazineModel);
    } catch (e) {
      log('Error fetching magazines');
      return Left('Failed to fetch magazines');
    }
  }

  @override
  Future<Either<String, MagazineModel>> searchMagazinesByRangeDate({
    required String fromDate,
    required String toDate,
    required int pageNumber,
  }) async {
    try {
      // Create cache key from fromDate, toDate, and pageNumber
      final cacheKey = '${fromDate}_${toDate}_$pageNumber';

      // Check if cached filtered data exists
      if (_cachedFilteredMagazines != null &&
          _cachedFilteredMagazines!.containsKey(cacheKey) &&
          _lastFilteredFetchTime != null &&
          DateTime.now().difference(_lastFilteredFetchTime!) < _cacheDuration) {
        log('Returning cached filtered magazines for $cacheKey');
        return Right(_cachedFilteredMagazines![cacheKey]!);
      }

      log(
        'Fetching filtered magazines from API: from=$fromDate, to=$toDate, page=$pageNumber',
      );
      // Fetch from API
      final response = await _dioHelper.getData(
        url: ApiEndpoints.magazines.path,
        query: {
          'from': fromDate,
          'to': toDate,
          'pageNumber': pageNumber,
          'pageSize': 30,
        },
      );

      // Ensure response.data is a Map
      final jsonData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : throw Exception(
              'Invalid response format: expected Map but got ${response.data.runtimeType}',
            );

      final MagazineModel magazineModel = MagazineModel.fromJson(jsonData);

      // Cache the filtered result
      _cachedFilteredMagazines ??= {};
      _cachedFilteredMagazines![cacheKey] = magazineModel;
      _lastFilteredFetchTime = DateTime.now();

      return Right(magazineModel);
    } catch (e) {
      log('Error searching magazines');
      return Left('Failed to search magazines');
    }
  }
}
