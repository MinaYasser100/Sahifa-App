// lib/features/auth/data/models/register_request.dart

class RegisterRequest {
  final String userName;
  final String email;
  final String password;
  final String confirmPassword;
  final String? phone;

  const RegisterRequest({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      if (phone != null) 'phone': phone,
    };
  }
}
