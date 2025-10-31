// lib/core/services/auth_service.dart

import 'package:sahifa/core/services/secure_storage_service.dart';
import 'package:sahifa/core/services/token_service.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final _storage = SecureStorageService();
  final _tokenService = TokenService();

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _tokenService.isLoggedIn();
  }

  // Get user info
  Future<Map<String, String?>> getUserInfo() async {
    return await _storage.getUserInfo();
  }

  // Save user session
  Future<void> saveUserSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String name,
  }) async {
    await _tokenService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    await _storage.saveUserInfo(userId: userId, email: email, name: name);
  }

  // Clear user session (logout)
  Future<void> clearUserSession() async {
    await _tokenService.clearTokens();
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _tokenService.getAccessToken();
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _tokenService.getRefreshToken();
  }
}
