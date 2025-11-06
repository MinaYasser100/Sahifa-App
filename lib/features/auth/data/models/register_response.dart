// lib/features/auth/data/models/register_response.dart

class RegisterResponse {
  final String message;

  const RegisterResponse({required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      message: json['message'] ?? 'User registered successfully',
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}
