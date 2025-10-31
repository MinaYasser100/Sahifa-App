// lib/features/auth/manager/auth_cubit/auth_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/services/auth_service.dart';
import 'package:sahifa/core/services/token_service.dart';
import 'package:sahifa/features/auth/data/models/login_request.dart';
import 'package:sahifa/features/auth/data/models/refresh_token_request.dart';
import 'package:sahifa/features/auth/data/models/register_request.dart';
import 'package:sahifa/features/auth/data/models/user_model.dart';
import 'package:sahifa/features/auth/data/repo/auth_repo.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final AuthService _authService = AuthService();
  final TokenService _tokenService = TokenService();

  AuthCubit(this._authRepo) : super(const AuthInitial()) {
    _checkAuthStatus();
    _setupTokenRefreshCallback();
  }

  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    emit(const AuthLoading());

    try {
      final isLoggedIn = await _authService.isLoggedIn();

      if (isLoggedIn) {
        final userInfo = await _authService.getUserInfo();

        if (userInfo['userId'] != null && userInfo['email'] != null) {
          // Create user model from stored info
          final user = UserModel(
            id: userInfo['userId']!,
            name: userInfo['name'] ?? '',
            email: userInfo['email']!,
            createdAt: DateTime.now(), // Placeholder
          );

          emit(Authenticated(user: user));
        } else {
          emit(const Unauthenticated());
        }
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(const Unauthenticated());
    }
  }

  // Setup token refresh callback
  void _setupTokenRefreshCallback() {
    _tokenService.onTokenRefreshNeeded = () async {
      return await _refreshToken();
    };
  }

  // Login
  Future<void> login(LoginRequest request) async {
    emit(const AuthLoading());

    final result = await _authRepo.login(request);

    result.fold(
      (error) {
        emit(AuthError(message: error));
      },
      (response) async {
        // Save tokens and user info
        await _authService.saveUserSession(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          userId: response.user.id,
          email: response.user.email,
          name: response.user.name,
        );

        emit(Authenticated(user: response.user));
      },
    );
  }

  // Register
  Future<void> register(RegisterRequest request) async {
    emit(const AuthLoading());

    final result = await _authRepo.register(request);

    result.fold(
      (error) {
        emit(AuthError(message: error));
      },
      (response) async {
        // Save tokens and user info
        await _authService.saveUserSession(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
          userId: response.user.id,
          email: response.user.email,
          name: response.user.name,
        );

        emit(Authenticated(user: response.user));
      },
    );
  }

  // Refresh token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _authService.getRefreshToken();

      if (refreshToken == null) {
        return false;
      }

      final result = await _authRepo.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      return result.fold(
        (error) {
          return false;
        },
        (response) async {
          // Save new tokens
          await _tokenService.saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

          return true;
        },
      );
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final refreshToken = await _authService.getRefreshToken();

      if (refreshToken != null) {
        // Call logout API
        await _authRepo.logout(refreshToken);
      }

      // Clear local session
      await _authService.clearUserSession();

      emit(const Unauthenticated());
    } catch (e) {
      // Still clear local session even if API call fails
      await _authService.clearUserSession();
      emit(const Unauthenticated());
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final result = await _authRepo.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );

    result.fold(
      (error) {
        emit(AuthError(message: error));
      },
      (_) {
        // Keep current state (still authenticated)
      },
    );
  }

  // Get current user
  UserModel? get currentUser {
    if (state is Authenticated) {
      return (state as Authenticated).user;
    }
    return null;
  }

  // Check if authenticated
  bool get isAuthenticated => state is Authenticated;

  // Update profile
  Future<void> updateProfile({required String name, String? phone}) async {
    final result = await _authRepo.updateProfile(name: name, phone: phone);

    result.fold(
      (error) {
        emit(AuthError(message: error));
      },
      (updatedUser) async {
        // Update stored user info
        await _authService.saveUserSession(
          accessToken: await _authService.getAccessToken() ?? '',
          refreshToken: await _authService.getRefreshToken() ?? '',
          userId: updatedUser.id,
          email: updatedUser.email,
          name: updatedUser.name,
        );

        emit(Authenticated(user: updatedUser));
      },
    );
  }

  // Confirm email
  Future<void> confirmEmail({
    required String token,
  }) async {
    emit(const AuthLoading());

    final result = await _authRepo.confirmEmail(
      token: token,
    );

    result.fold(
      (error) => emit(AuthError(message: error)),
      (_) {
        // Email confirmed successfully
        // User needs to login after confirmation
        emit(const Unauthenticated());
      },
    );
  }
}
