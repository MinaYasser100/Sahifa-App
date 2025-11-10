// lib/core/services/secure_storage_service.dart

import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();
  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  // Secure Storage للـ sensitive data (tokens, user info)
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // Shared Preferences للـ login state بس
  SharedPreferences? _prefs;

  // Keys للـ Secure Storage (sensitive data)
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiresAtKey = 'token_expires_at';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';

  // Keys للـ Shared Preferences (non-sensitive)
  static const String _isLoggedInKey = 'is_logged_in';

  // Initialize Shared Preferences
  Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Access Token (Secure Storage)
  Future<void> saveAccessToken(String token, {int? expiresIn}) async {
    log('🔐 [SecureStorage] Saving access token: ${token.substring(0, 20)}...');
    await _secureStorage.write(key: _accessTokenKey, value: token);
    log('✅ [SecureStorage] Access token saved');

    // Save expiration time if provided
    if (expiresIn != null) {
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));
      await _secureStorage.write(
        key: _tokenExpiresAtKey,
        value: expiresAt.toIso8601String(),
      );
      log('⏰ [SecureStorage] Token expires at: $expiresAt');
    }

    // Mark as logged in
    await _setLoggedInState(true);
    log('✅ [SecureStorage] Login state set to true');
  }

  Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: _accessTokenKey);
  }

  // Refresh Token (Secure Storage)
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: _refreshTokenKey);
  }

  // Token Expiration
  Future<DateTime?> getTokenExpiresAt() async {
    final expiresAtStr = await _secureStorage.read(key: _tokenExpiresAtKey);
    if (expiresAtStr != null) {
      try {
        return DateTime.parse(expiresAtStr);
      } catch (e) {
        log('❌ [SecureStorage] Failed to parse token expiry: $e');
        return null;
      }
    }
    return null;
  }

  Future<bool> isTokenExpired() async {
    final expiresAt = await getTokenExpiresAt();
    if (expiresAt == null) {
      log('⚠️ [SecureStorage] No token expiry found, assuming expired');
      return true; // Assume expired if no expiry time
    }

    final now = DateTime.now();
    final isExpired = now.isAfter(expiresAt);
    log(
      '🕐 [SecureStorage] Token expired: $isExpired (expires at: $expiresAt, now: $now)',
    );
    return isExpired;
  }

  // User Info (Secure Storage)
  Future<void> saveUserInfo({
    required String userId,
    required String email,
    required String name,
  }) async {
    await Future.wait([
      _secureStorage.write(key: _userIdKey, value: userId),
      _secureStorage.write(key: _userEmailKey, value: email),
      _secureStorage.write(key: _userNameKey, value: name),
    ]);
  }

  Future<Map<String, String?>> getUserInfo() async {
    final userId = await _secureStorage.read(key: _userIdKey);
    final email = await _secureStorage.read(key: _userEmailKey);
    final name = await _secureStorage.read(key: _userNameKey);

    return {'userId': userId, 'email': email, 'name': name};
  }

  // Login State Management (Shared Preferences)
  Future<void> _setLoggedInState(bool isLoggedIn) async {
    await _initPrefs();
    print('📝 [SecureStorage] Setting login state to: $isLoggedIn');
    await _prefs!.setBool(_isLoggedInKey, isLoggedIn);
    final saved = _prefs!.getBool(_isLoggedInKey);
    print('✅ [SecureStorage] Login state saved and verified: $saved');
  }

  Future<bool> isLoggedIn() async {
    await _initPrefs();
    final loggedIn = _prefs!.getBool(_isLoggedInKey) ?? false;
    print('🔍 [SecureStorage] Checking login state: $loggedIn');
    return loggedIn;
  }

  // Clear all data (both secure storage and preferences)
  Future<void> clearAll() async {
    // Clear secure storage (sensitive data)
    await _secureStorage.deleteAll();

    // Clear login state
    await _initPrefs();
    await _prefs!.setBool(_isLoggedInKey, false);
  }

  // Delete specific token
  Future<void> deleteAccessToken() async {
    await _secureStorage.delete(key: _accessTokenKey);
  }

  Future<void> deleteRefreshToken() async {
    await _secureStorage.delete(key: _refreshTokenKey);
  }
}
