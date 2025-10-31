// lib/features/auth/data/repo/auth_repo.dart

import 'package:dartz/dartz.dart';
import 'package:sahifa/features/auth/data/models/login_request.dart';
import 'package:sahifa/features/auth/data/models/login_response.dart';
import 'package:sahifa/features/auth/data/models/refresh_token_request.dart';
import 'package:sahifa/features/auth/data/models/refresh_token_response.dart';
import 'package:sahifa/features/auth/data/models/register_request.dart';
import 'package:sahifa/features/auth/data/models/register_response.dart';
import 'package:sahifa/features/auth/data/models/user_model.dart';

abstract class AuthRepo {
  Future<Either<String, LoginResponse>> login(LoginRequest request);
  
  Future<Either<String, RegisterResponse>> register(RegisterRequest request);
  
  Future<Either<String, RefreshTokenResponse>> refreshToken(
    RefreshTokenRequest request,
  );
  
  Future<Either<String, void>> logout(String refreshToken);
  
  Future<Either<String, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
  
  Future<Either<String, void>> forgotPassword(String email);
  
  Future<Either<String, void>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  });
  
  Future<Either<String, UserModel>> updateProfile({
    required String name,
    String? phone,
  });
  
  Future<Either<String, void>> confirmEmail({
    required String token,
  });
}
