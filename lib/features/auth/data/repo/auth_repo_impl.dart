// lib/features/auth/data/repo/auth_repo_impl.dart

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
        final loginResponse = LoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        final errorMessage = response.data['message'] ?? 'failed_login'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'login_error'.tr();
      return Left(errorMessage);
    } catch (e) {
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
        final errorMessage = response.data['message'] ?? 'registration_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'registration_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
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
        final errorMessage = response.data['message'] ?? 'token_refresh_failed'.tr();
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
      final errorMessage =
          e.response?.data['message'] ?? 'logout_error'.tr();
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
            response.data['message'] ??
            'forgot_password_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ??
          'forgot_password_error'.tr();
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
          e.response?.data['message'] ??
          'reset_password_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
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
        final updatedUser = UserModel.fromJson(response.data['user']);
        return Right(updatedUser);
      } else {
        final errorMessage =
            response.data['message'] ?? 'profile_update_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'profile_update_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }

  @override
  Future<Either<String, void>> confirmEmail({
    required String token,
  }) async {
    try {
      final response = await _dioHelper.postData(
        url: ApiEndpoints.confirmEmail.path,
        data: {
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        return const Right(null);
      } else {
        final errorMessage =
            response.data['message'] ?? 'email_confirmation_failed'.tr();
        return Left(errorMessage);
      }
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data['message'] ?? 'email_confirmation_error'.tr();
      return Left(errorMessage);
    } catch (e) {
      return Left('unexpected_error'.tr());
    }
  }
}
