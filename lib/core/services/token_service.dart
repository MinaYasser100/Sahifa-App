// lib/core/services/token_service.dart

import 'dart:async';
import 'dart:developer';
import 'package:sahifa/core/services/secure_storage_service.dart';

class TokenService {
  static final TokenService _instance = TokenService._internal();
  factory TokenService() => _instance;
  TokenService._internal();

  final _storage = SecureStorageService();
  Timer? _refreshTimer;

  // Callback للـ refresh token API call
  Future<bool> Function()? onTokenRefreshNeeded;

  // Save tokens and schedule auto-refresh
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    log('💾 [TokenService] Saving tokens...');
    log('🔑 [TokenService] Access token length: ${accessToken.length}');
    log('🔑 [TokenService] Refresh token length: ${refreshToken.length}');

    await _storage.saveAccessToken(accessToken);
    log('✅ [TokenService] Access token saved via SecureStorage');

    await _storage.saveRefreshToken(refreshToken);
    log('✅ [TokenService] Refresh token saved via SecureStorage');

    _scheduleTokenRefresh();
    log('⏰ [TokenService] Token refresh scheduled');
  }

  // Get access token
  Future<String?> getAccessToken() async {
    return await _storage.getAccessToken();
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.getRefreshToken();
  }

  // Schedule auto-refresh (25 minutes = قبل الـ 30 دقيقة بـ 5 دقائق)
  void _scheduleTokenRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer(
      const Duration(minutes: 25), // 25 دقيقة
      () async {
        await refreshAccessToken();
      },
    );
  }

  // Refresh access token
  Future<bool> refreshAccessToken() async {
    try {
      if (onTokenRefreshNeeded != null) {
        final success = await onTokenRefreshNeeded!();

        if (success) {
          _scheduleTokenRefresh(); // Schedule next refresh
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Clear tokens and cancel timer
  Future<void> clearTokens() async {
    _refreshTimer?.cancel();
    await _storage.clearAll();
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    return await _storage.isLoggedIn();
  }

  // Cancel timer (call this when app is disposed)
  void dispose() {
    _refreshTimer?.cancel();
  }
}
