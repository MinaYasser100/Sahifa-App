// lib/features/auth/data/repo/auth_repo_impl.dart

import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sahifa/core/helper_network/api_endpoints.dart';
import 'package:sahifa/core/helper_network/dio_helper.dart';
import 'package:sahifa/features/auth/data/models/login_request.dart';
import 'package:sahifa/features/auth/data/models/login_response.dart';
import 'package:sahifa/features/auth/data/models/refresh_token_request.dart';
import 'package:sahifa/features/auth/data/models/refresh_token_response.dart';
import 'package:sahifa/features/auth/data/models/register_request.dart';
import 'package:sahifa/features/auth/data/models/register_response.dart';
import 'package:sahifa/features/auth/data/models/user_model.dart';
import 'package:sahifa/features/auth/data/repo/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final DioHelper _dioHelper;

  AuthRepoImpl(this._dioHelper);

  @override
  Future<Either<String, LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.login.path,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        log('✅ Login API returned 200');
        log('📊 Response data: ${response.data}');
        final loginResponse = LoginResponse.fromJson(response.data);
        log(
          '🔑 Access token: ${loginResponse.accessToken.substring(0, 20)}...',
        );
        log(
          '🔑 Refresh token: ${loginResponse.refreshToken.substring(0, 20)}...',
        );
        return Right(loginResponse);
      } else {
        log('❌ Login failed with status: ${response.statusCode}');
        log('📊 Response data: ${response.data}');
        return Left(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      log('❌ DioException during login: ${e.message}');
      log('📊 Response status: ${e.response?.statusCode}');
      log('📊 Response data: ${e.response?.data}');
      return Left(_extractErrorMessage(e.response?.data));
    } catch (e, stackTrace) {
      log('❌ Unexpected error during login: $e');
      log('📍 Stack trace: $stackTrace');
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, RegisterResponse>> register(
    RegisterRequest request,
  ) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.register.path,
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(response.data);
        return Right(registerResponse);
      } else {
        return Left(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      return Left(_extractErrorMessage(e.response?.data));
    } catch (e) {
      return Left('');
    }
  }

  @override
  Future<Either<String, RefreshTokenResponse>> refreshToken(
    RefreshTokenRequest request,
  ) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.refreshToken.path,
        data: request.toJson(),
      );

      if (response.statusCode == 200) {
        final refreshResponse = RefreshTokenResponse.fromJson(response.data);
        return Right(refreshResponse);
      } else {
        final errorMessage =
            response.data['message'] ?? 'token_refresh_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'token_refresh_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, void>> logout(String refreshToken) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.logout.path,
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorMessage = response.data['message'] ?? 'logout_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage = e.response?.data['message'] ?? 'logout_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.changePassword.path,
        data: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPasswordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorMessage =
            response.data['message'] ?? 'password_change_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'password_change_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, void>> forgotPassword(String email) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.forgotPassword.path,
        data: {'email': email},
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorMessage =
            response.data['message'] ?? 'forgot_password_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'forgot_password_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, void>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.resetPassword.path,
        data: {
          'email': email,
          'token': token,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorMessage =
            response.data['message'] ?? 'reset_password_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'reset_password_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, UserModel>> getUserProfile() async {
    try {
      final response = await _dioHelper.getData(
        url: ApiEndpoints.getUserProfile.path,
      );

      if (response.statusCode == 200) {
        // Log the response data for debugging
        log('📊 User Profile Response: ${response.data}');
        final user = UserModel.fromJson(response.data);
        return Right(user);
      } else {
        return Left(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      return Left(_extractErrorMessage(e.response?.data));
    } catch (e, stackTrace) {
      log('❌ Error parsing user profile: $e');
      log('📍 Stack trace: $stackTrace');
      return Left('${'failed_to_fetch_user_profile'.tr()}: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, UserModel>> updateProfile({
    required String name,
    String? phone,
  }) async {
    try {
      final data = <String, dynamic>{
        'name': name,
        if (phone != null && phone.isNotEmpty) 'phone': phone,
      };

      final response = await _dioHelper.putData(
        url: ApiEndpoints.updateProfile.path,
        data: data,
      );

      if (response.statusCode == 200) {
        final updatedUser = UserModel.fromJson(response.data);
        return Right(updatedUser);
      } else {
        return Left(_extractErrorMessage(response.data));
      }
    } on DioException catch (e) {
      return Left(_extractErrorMessage(e.response?.data));
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  // Helper method to extract error messages from backend response
  String _extractErrorMessage(dynamic responseData) {
    log('🔍 Extracting error from response data: $responseData');

    if (responseData == null) {
      log('⚠️ Response data is null');
      return 'server_error'.tr();
    }

    // Check for 'detail' field (400, 401, etc.)
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('detail')) {
      final detail = responseData['detail'] as String;
      log('✅ Found detail field: $detail');
      return detail;
    }

    // Check for 'errors' field (422 Validation Errors)
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('errors')) {
      final errors = responseData['errors'] as Map<String, dynamic>;

      // Collect all error messages
      final List<String> errorMessages = [];
      errors.forEach((field, messages) {
        if (messages is List) {
          for (var message in messages) {
            errorMessages.add(message.toString());
          }
        }
      });

      // Return first error or all errors joined
      if (errorMessages.isNotEmpty) {
        log('✅ Found validation errors: ${errorMessages.first}');
        return errorMessages.first; // Return first error for simplicity
      }
    }

    // Check for 'message' field (custom API messages)
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('message')) {
      final message = responseData['message'] as String;
      log('✅ Found message field: $message');
      return message;
    }

    // Check for 'title' field (Problem Details)
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('title')) {
      final title = responseData['title'] as String;
      log('✅ Found title field: $title');
      return title;
    }

    // Default error
    log('⚠️ No known error field found, returning default');
    return 'unexpected_error'.tr();
  }
}
