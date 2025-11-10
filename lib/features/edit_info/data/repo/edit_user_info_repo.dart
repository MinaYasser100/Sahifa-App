import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/edit_info/data/model/user_update_model.dart';
import 'package:sahifa/features/profile/data/model/public_user_profile_model.dart';

abstract class EditUserInfoRepo {
  Future<Either<String, PublicUserProfileModel>> updateUserInfo({
    required String userId,
    required UserUpdateModel updateModel,
  });
}

class EditUserInfoRepoImpl implements EditUserInfoRepo {
  // Singleton Pattern
  static final EditUserInfoRepoImpl _instance = EditUserInfoRepoImpl._internal(
    DioHelper(),
  );
  factory EditUserInfoRepoImpl() => _instance;

  EditUserInfoRepoImpl._internal(this._dioHelper);

  final DioHelper _dioHelper;

  @override
  Future<Either<String, PublicUserProfileModel>> updateUserInfo({
    required String userId,
    required UserUpdateModel updateModel,
  }) async {
    try {
      log('🔄 Updating user profile', name: 'EditUserInfoRepo');

      final url = ApiEndpoints.updateUserInfo.withParams({'id': userId});
      log('📍 URL: $url', name: 'EditUserInfoRepo');

      // Always use multipart/form-data as the API expects it
      final Map<String, dynamic> formDataMap = {
        'userId': updateModel.userId, // Always send userId
        'userName': updateModel.userName,
        'slug': updateModel.slug,
      };

      // Add optional fields only if they have values
      if (updateModel.aboutMe != null && updateModel.aboutMe!.isNotEmpty) {
        formDataMap['aboutMe'] = updateModel.aboutMe;
      }

      // Add avatar image if a new one was selected
      if (updateModel.avatarImage != null &&
          updateModel.avatarImage!.isNotEmpty) {
        log('📸 Adding new avatar image', name: 'EditUserInfoRepo');
        formDataMap['avatarImage'] = await MultipartFile.fromFile(
          updateModel.avatarImage!,
          filename: 'avatar.jpg',
        );
      }

      // Add social accounts if provided
      if (updateModel.socialAccounts != null &&
          updateModel.socialAccounts!.isNotEmpty) {
        formDataMap['socialAccounts'] = updateModel.socialAccounts;
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await _dioHelper.putMultipartData(
        url: url,
        formData: formData,
      );

      if (response.statusCode == 200) {
        log('✅ User info updated successfully', name: 'EditUserInfoRepo');
        final updatedProfile = PublicUserProfileModel.fromJson(response.data);
        return Right(updatedProfile);
      } else {
        final errorMessage = _extractErrorMessage(response.data);
        log('❌ Update failed: $errorMessage', name: 'EditUserInfoRepo');
        return Left(errorMessage ?? "failed_to_update_profile".tr());
      }
    } on DioException catch (e) {
      log(
        '❌ DioException updating user info: ${e.message}',
        name: 'EditUserInfoRepo',
      );

      // Handle specific error codes
      if (e.response?.statusCode == 400) {
        final errorMsg = _extractErrorMessage(e.response?.data);
        return Left(errorMsg ?? "invalid_data_error".tr());
      }

      if (e.response?.statusCode == 404) {
        return Left("user_not_found_error".tr());
      }

      if (e.response?.statusCode == 409) {
        final errorMsg = _extractErrorMessage(e.response?.data);
        return Left(errorMsg ?? "username_already_exists".tr());
      }

      if (e.response?.statusCode == 422) {
        final errorMsg = _extractErrorMessage(e.response?.data);
        return Left(errorMsg ?? "validation_error".tr());
      }

      return Left("failed_to_update_profile".tr());
    } catch (e) {
      log('❌ Unexpected error: $e', name: 'EditUserInfoRepo');
      return Left("unexpected_error".tr());
    }
  }

  /// Extract error message from response data
  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;

    try {
      if (data is Map<String, dynamic>) {
        // Try to get message from different possible keys
        if (data['message'] != null) {
          return data['message'].toString();
        }
        if (data['error'] != null) {
          return data['error'].toString();
        }
        if (data['errors'] != null) {
          // Handle validation errors
          if (data['errors'] is Map) {
            final errors = data['errors'] as Map<String, dynamic>;
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first.toString();
            }
            return firstError.toString();
          }
        }
      }
    } catch (e) {
      log('⚠️ Error extracting error message: $e', name: 'EditUserInfoRepo');
    }

    return null;
  }
}
