// lib/core/errors/failures.dart

abstract class Failure {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  String toString() => message;
}

// Network Failures
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message}) : super(statusCode: null);
}

// Server Failures
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});
}

// Authentication Failures
class AuthenticationFailure extends Failure {
  const AuthenticationFailure({required super.message}) : super(statusCode: 401);
}

// Authorization Failures
class AuthorizationFailure extends Failure {
  const AuthorizationFailure({required super.message}) : super(statusCode: 403);
}

// Validation Failures
class ValidationFailure extends Failure {
  final Map<String, List<String>>? errors;

  const ValidationFailure({
    required super.message,
    this.errors,
  }) : super(statusCode: 422);
}

// Cache Failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message}) : super(statusCode: null);
}
