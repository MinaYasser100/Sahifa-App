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
    int? expiresIn,
  }) async {
    log('💾 [TokenService] Saving tokens...');
    log('🔑 [TokenService] Access token length: ${accessToken.length}');
    log('🔑 [TokenService] Refresh token length: ${refreshToken.length}');
    log('⏰ [TokenService] Expires in: ${expiresIn ?? "not provided"} seconds');

    await _storage.saveAccessToken(accessToken, expiresIn: expiresIn);
    log('✅ [TokenService] Access token saved via SecureStorage');

    await _storage.saveRefreshToken(refreshToken);
    log('✅ [TokenService] Refresh token saved via SecureStorage');

    _scheduleTokenRefresh(expiresIn);
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

  // Schedule auto-refresh (5 minutes before expiry)
  void _scheduleTokenRefresh(int? expiresIn) {
    _refreshTimer?.cancel();

    // If expiresIn is provided, schedule refresh 5 minutes before expiry
    // Otherwise default to 25 minutes
    final duration = expiresIn != null
        ? Duration(seconds: expiresIn - 300) // 5 minutes before expiry
        : const Duration(minutes: 25);

    log(
      '⏰ [TokenService] Scheduling token refresh in ${duration.inMinutes} minutes',
    );

    _refreshTimer = Timer(duration, () async {
      log('⏰ [TokenService] Auto-refresh triggered');
      await refreshAccessToken();
    });
  }

  // Refresh access token
  Future<bool> refreshAccessToken() async {
    log('🔄 [TokenService] Starting token refresh...');
    try {
      if (onTokenRefreshNeeded != null) {
        final success = await onTokenRefreshNeeded!();

        if (success) {
          log('✅ [TokenService] Token refreshed successfully');
          // Note: _scheduleTokenRefresh will be called by saveTokens
          return true;
        } else {
          log('❌ [TokenService] Token refresh failed');
          return false;
        }
      } else {
        log('⚠️ [TokenService] No refresh callback registered');
        return false;
      }
    } catch (e) {
      log('❌ [TokenService] Error during token refresh: $e');
      return false;
    }
  }

  // Check if token is expired and needs refresh
  Future<bool> isTokenExpired() async {
    return await _storage.isTokenExpired();
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
