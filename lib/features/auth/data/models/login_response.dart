// lib/features/auth/data/models/login_response.dart

import 'dart:developer';

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    log('🔍 [LoginResponse] Parsing JSON: $json');

    final accessToken = json['accessToken'] as String?;
    final refreshToken = json['refreshToken'] as String?;
    final expiresIn = json['expiresIn'] as int?;

    log(
      '🔑 [LoginResponse] Access token: ${accessToken?.substring(0, accessToken.length > 20 ? 20 : accessToken.length)}...',
    );
    log(
      '🔑 [LoginResponse] Refresh token: ${refreshToken?.substring(0, refreshToken.length > 20 ? 20 : refreshToken.length)}...',
    );
    log('⏰ [LoginResponse] Expires in: $expiresIn');

    if (accessToken == null || accessToken.isEmpty) {
      log('❌ [LoginResponse] Access token is missing or empty!');
      throw Exception('Access token is missing in login response');
    }

    if (refreshToken == null || refreshToken.isEmpty) {
      log('❌ [LoginResponse] Refresh token is missing or empty!');
      throw Exception('Refresh token is missing in login response');
    }

    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn ?? 3600,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresIn': expiresIn,
    };
  }
}
