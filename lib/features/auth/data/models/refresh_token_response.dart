// lib/features/auth/data/models/refresh_token_response.dart

class RefreshTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;

  const RefreshTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    return RefreshTokenResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
    };
  }
}
