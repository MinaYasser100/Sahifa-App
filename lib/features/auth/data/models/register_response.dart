// lib/features/auth/data/models/register_response.dart

import 'package:sahifa/features/auth/data/models/user_model.dart';

class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final UserModel user;
  final String? message;

  const RegisterResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.user,
    this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      user: UserModel.fromJson(json['user']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user': user.toJson(),
      if (message != null) 'message': message,
    };
  }
}
