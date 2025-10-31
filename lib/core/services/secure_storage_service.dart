// lib/core/services/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  
  SecureStorageService._internal();

  // Secure Storage للـ sensitive data (tokens, user info)
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  // Shared Preferences للـ login state بس
  SharedPreferences? _prefs;

  // Keys للـ Secure Storage (sensitive data)
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
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
  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(key: _accessTokenKey, value: token);
    // Mark as logged in
    await _setLoggedInState(true);
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
    
    return {
      'userId': userId,
      'email': email,
      'name': name,
    };
  }

  // Login State Management (Shared Preferences)
  Future<void> _setLoggedInState(bool isLoggedIn) async {
    await _initPrefs();
    await _prefs!.setBool(_isLoggedInKey, isLoggedIn);
  }

  Future<bool> isLoggedIn() async {
    await _initPrefs();
    return _prefs!.getBool(_isLoggedInKey) ?? false;
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
