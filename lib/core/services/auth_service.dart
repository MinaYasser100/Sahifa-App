// lib/core/services/auth_service.dart

import 'dart:developer';
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
    log('🔍 Checking login status...', name: 'AuthService');
    final isLoggedIn = await _tokenService.isLoggedIn();
    log('📊 Login status: $isLoggedIn', name: 'AuthService');
    return isLoggedIn;
  }

  // Get user info
  Future<Map<String, String?>> getUserInfo() async {
    log('👤 Getting user info from storage...', name: 'AuthService');
    final userInfo = await _storage.getUserInfo();
    log('📋 User info retrieved: ${userInfo['email']}', name: 'AuthService');
    return userInfo;
  }

  // Save user session
  Future<void> saveUserSession({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String email,
    required String name,
  }) async {
    log('💾 Saving user session...', name: 'AuthService');
    log('👤 User: $name ($email)', name: 'AuthService');
    log('🔑 User ID: $userId', name: 'AuthService');

    await _tokenService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    log('✅ Tokens saved', name: 'AuthService');

    await _storage.saveUserInfo(userId: userId, email: email, name: name);
    log('✅ User info saved', name: 'AuthService');
  }

  // Clear user session (logout)
  Future<void> clearUserSession() async {
    log('🧹 Clearing user session...', name: 'AuthService');
    await _tokenService.clearTokens();
    log('✅ Session cleared', name: 'AuthService');
  }

  // Get access token
  Future<String?> getAccessToken() async {
    final token = await _tokenService.getAccessToken();
    log(
      '🎫 Access token retrieved: ${token != null ? "Yes" : "No"}',
      name: 'AuthService',
    );
    return token;
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    final token = await _tokenService.getRefreshToken();
    log(
      '🎫 Refresh token retrieved: ${token != null ? "Yes" : "No"}',
      name: 'AuthService',
    );
    return token;
  }
}
