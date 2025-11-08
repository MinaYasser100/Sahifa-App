// lib/features/auth/manager/auth_cubit/auth_state.dart

import 'package:sahifa/features/auth/data/models/user_model.dart';

abstract class AuthState {
  const AuthState();
}

// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

// Loading state (checking auth status)
class AuthLoading extends AuthState {
  const AuthLoading();
}

// Authenticated state
class Authenticated extends AuthState {
  final UserModel user;

  const Authenticated({required this.user});
}

// Unauthenticated state
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// Auth error state
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});
}
