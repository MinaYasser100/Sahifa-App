import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/core/model/galleries_model/galleries_model.dart';

abstract class DetailsGalleryRepo {
  Future<Either<String, GalleriesModel>> fetchGalleryDetails({
    required String categorySlug,
    required String gallerySlug,
  });
  void clearCache();
}

class DetailsGalleryRepoImpl implements DetailsGalleryRepo {
  late DioHelper _dioHelper;

  // Singleton pattern
  static final DetailsGalleryRepoImpl _instance =
      DetailsGalleryRepoImpl._internal();
  factory DetailsGalleryRepoImpl(DioHelper dioHelper) {
    _instance._dioHelper = dioHelper;
    return _instance;
  }
  DetailsGalleryRepoImpl._internal();

  // Cache with ETag support
  final Map<String, GalleriesModel> _cache = {};
  final Map<String, String> _etags = {};

  @override
  Future<Either<String, GalleriesModel>> fetchGalleryDetails({
    required String categorySlug,
    required String gallerySlug,
  }) async {
    try {
      final cacheKey = '${categorySlug}_$gallerySlug';

      // Replace path parameters
      final url = ApiEndpoints.getGallery.withParams({
        'categorySlug': categorySlug,
        'slug': gallerySlug,
      });

      // Prepare headers with ETag if available
      final headers = <String, dynamic>{};
      if (_etags.containsKey(cacheKey)) {
        headers['If-None-Match'] = _etags[cacheKey];
        log('🏷️ Sending ETag for $cacheKey: ${_etags[cacheKey]}');
      } else {
        log('🆕 No ETag for $cacheKey - First request');
      }

      final response = await _dioHelper.getData(
        url: url,
        headers: headers.isNotEmpty ? headers : null,
        query: {'categorySlug': categorySlug, 'slug': gallerySlug},
      );

      log('📥 Response status: ${response.statusCode} for $cacheKey');

      // Handle 304 Not Modified - return cached data
      if (response.statusCode == 304) {
        log('✅ 304 Not Modified - Gallery details cache hit for: $cacheKey');
        if (_cache.containsKey(cacheKey)) {
          return Right(_cache[cacheKey]!);
        }
        return Left("error_fetching_gallery_details".tr());
      }

      // Check if response.data is directly the gallery object or wrapped in 'data'
      final galleryData =
          response.data is Map<String, dynamic> &&
              response.data.containsKey('data')
          ? response.data['data']
          : response.data;

      final GalleriesModel galleriesModel = GalleriesModel.fromJson(
        galleryData,
      );

      // Store in cache
      _cache[cacheKey] = galleriesModel;

      // Store ETag if present
      if (response.headers.value('etag') != null) {
        _etags[cacheKey] = response.headers.value('etag')!;
        log('📦 Stored ETag for $cacheKey: ${_etags[cacheKey]}');
      }

      return Right(galleriesModel);
    } catch (e) {
      log("Error fetching gallery details: $e");
      return Left("error_fetching_gallery_details".tr());
    }
  }

  @override
  void clearCache() {
    _cache.clear();
    _etags.clear();
    log('Gallery details cache cleared');
  }
}
