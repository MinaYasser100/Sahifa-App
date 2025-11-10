import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/cache/generic_etag_handler.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/profile/data/model/public_user_profile_model.dart';

abstract class ProfileUserRepo {
  Future<Either<String, PublicUserProfileModel>> getPublicUserProfile({
    required String username,
  });
}

class ProfileUserRepoImpl implements ProfileUserRepo {
  // Singleton Pattern
  static final ProfileUserRepoImpl _instance = ProfileUserRepoImpl._internal(
    DioHelper(),
  );
  factory ProfileUserRepoImpl() => _instance;

  ProfileUserRepoImpl._internal(this._dioHelper) {
    _etagHandler = GenericETagHandler(handlerIdentifier: 'ProfileUser');
  }

  final DioHelper _dioHelper;
  late final GenericETagHandler _etagHandler;

  // Store ETags per username (for HTTP caching only)
  final Map<String, String> _etagsByUsername = {};
  // Store last response data for 304 handling
  final Map<String, PublicUserProfileModel> _lastResponseByUsername = {};

  @override
  Future<Either<String, PublicUserProfileModel>> getPublicUserProfile({
    required String username,
  }) async {
    try {
      log('🔍 Fetching public profile for: $username', name: 'ProfileUserRepo');

      // Make network request with ETag if available
      final response = await _makeRequest(username);

      _etagHandler.logResponseStatus(response, 0);

      // Handle 304 Not Modified
      if (_etagHandler.isNotModified(response)) {
        return _handle304Response(username);
      }

      // Handle 200 OK with new data
      return _handle200Response(response, username);
    } on DioException catch (e) {
      log(
        '❌ DioException fetching profile: ${e.message}',
        name: 'ProfileUserRepo',
      );

      // Handle 404 - User not found
      if (e.response?.statusCode == 404) {
        return Left("user_not_found".tr());
      }

      // Handle 422 - Validation error
      if (e.response?.statusCode == 422) {
        return Left("invalid_username".tr());
      }

      return Left("failed_to_load_profile".tr());
    } catch (e) {
      log('❌ Unexpected error: $e', name: 'ProfileUserRepo');
      return Left("failed_to_load_profile".tr());
    }
  }

  /// Make HTTP request with ETag headers
  Future<Response> _makeRequest(String username) async {
    final etag = _etagsByUsername[username];
    final headers = _etagHandler.prepareHeaders(etag, 0);

    final url = ApiEndpoints.getProfileUser.withParams({'username': username});

    return await _dioHelper.getData(
      url: url,
      query: {ApiQueryParams.userName: username},
      headers: headers,
    );
  }

  /// Handle 304 Not Modified response
  Either<String, PublicUserProfileModel> _handle304Response(String username) {
    log('✅ 304 Not Modified - Profile data unchanged for $username');

    // Return last known response for this username
    if (_lastResponseByUsername.containsKey(username)) {
      return Right(_lastResponseByUsername[username]!);
    }

    // If we don't have cached response, this shouldn't happen
    log('⚠️ Warning: 304 received but no cached response for $username');
    return Left("cached_data_missing".tr());
  }

  /// Handle 200 OK response with new data
  Either<String, PublicUserProfileModel> _handle200Response(
    Response response,
    String username,
  ) {
    log('📦 200 OK - Received new profile data for $username');

    try {
      // Log raw response for debugging
      log('📄 Raw response data: ${response.data}', name: 'ProfileUserRepo');

      // Check if socialAccounts exists in response
      if (response.data['socialAccounts'] != null) {
        log(
          '🔗 Social accounts in response: ${response.data['socialAccounts']}',
          name: 'ProfileUserRepo',
        );
      } else {
        log('⚠️ No socialAccounts in API response!', name: 'ProfileUserRepo');
      }

      // Extract and store ETag
      final etag = _etagHandler.extractETag(response, 0);
      if (etag != null) {
        _etagsByUsername[username] = etag;
      }

      // Parse response
      final profileModel = PublicUserProfileModel.fromJson(response.data);

      // Log parsed socialAccounts
      log(
        '📱 Parsed social accounts: ${profileModel.socialAccounts.accounts}',
        name: 'ProfileUserRepo',
      );

      // Store last response for 304 handling
      _lastResponseByUsername[username] = profileModel;

      return Right(profileModel);
    } catch (e) {
      log('❌ Error parsing profile data: $e', name: 'ProfileUserRepo');
      return Left("failed_to_parse_profile".tr());
    }
  }

  /// Force refresh - clears ETags to force new data
  Future<Either<String, PublicUserProfileModel>> forceRefresh(
    String username,
  ) async {
    log('🔄 Force refresh requested for $username - Clearing ETag');
    _etagsByUsername.remove(username);
    _lastResponseByUsername.remove(username);
    return getPublicUserProfile(username: username);
  }

  /// Clear all data (for logout)
  void clearAllCache() {
    log('🧹 Clearing all profile caches', name: 'ProfileUserRepo');
    _etagsByUsername.clear();
    _lastResponseByUsername.clear();
  }
}
