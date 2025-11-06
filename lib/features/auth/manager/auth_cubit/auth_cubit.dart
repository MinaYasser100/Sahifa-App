// lib/features/auth/manager/auth_cubit/auth_cubit.dart

import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/services/auth_service.dart';
import 'package:sahifa/core/services/token_service.dart';
import 'package:sahifa/core/utils/auth_error_handler.dart';
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
    _setupTokenRefreshCallback();
    // Don't auto-check auth status in constructor to avoid closed state issues
  }

  // Call this method explicitly when needed (e.g., from Splash screen)
  void checkAuthStatus() {
    _checkAuthStatus();
  }

  // Check if user is already logged in
  Future<void> _checkAuthStatus() async {
    if (isClosed) return; // Exit early if closed

    log('🔍 Checking authentication status...', name: 'AuthCubit');
    if (!isClosed) emit(const AuthLoading());

    try {
      final isLoggedIn = await _authService.isLoggedIn();
      log('📊 Login status: $isLoggedIn', name: 'AuthCubit');

      if (isLoggedIn) {
        final userInfo = await _authService.getUserInfo();
        log('👤 Retrieved user info: ${userInfo['email']}', name: 'AuthCubit');

        if (userInfo['userId'] != null && userInfo['email'] != null) {
          // Create user model from stored info
          final user = UserModel(
            id: userInfo['userId']!,
            name: userInfo['name'] ?? '',
            email: userInfo['email']!,
            createdAt: DateTime.now(), // Placeholder
          );

          log('✅ User authenticated: ${user.email}', name: 'AuthCubit');
          if (!isClosed) emit(Authenticated(user: user));
        } else {
          log(
            '⚠️ Incomplete user info, marking as unauthenticated',
            name: 'AuthCubit',
          );
          if (!isClosed) emit(const Unauthenticated());
        }
      } else {
        log('❌ User not logged in', name: 'AuthCubit');
        if (!isClosed) emit(const Unauthenticated());
      }
    } catch (e) {
      log('❌ Error checking auth status: $e', name: 'AuthCubit');
      if (!isClosed) emit(const Unauthenticated());
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
    if (isClosed) return; // Exit early if closed

    log('🔐 Starting login process...', name: 'AuthCubit');
    AuthErrorHandler.logAuthAttempt('Login', request.email);

    if (!isClosed) emit(const AuthLoading());

    try {
      log('📡 Sending login request to API...', name: 'AuthCubit');
      final result = await _authRepo.login(request);

      result.fold(
        (error) {
          log('❌ Login API returned error: $error', name: 'AuthCubit');
          AuthErrorHandler.logAuthFailure('Login', request.email, error);

          // Parse error message to get user-friendly text
          final errorMessage = _parseErrorMessage(error);
          log('🔴 Emitting error state: $errorMessage', name: 'AuthCubit');

          if (!isClosed) emit(AuthError(message: errorMessage));
        },
        (response) async {
          log('✅ Login successful', name: 'AuthCubit');
          log('💾 Saving tokens...', name: 'AuthCubit');

          // Save tokens first
          await _tokenService.saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

          log('👤 Fetching user profile...', name: 'AuthCubit');
          // Fetch user profile
          final userResult = await _authRepo.getUserProfile();

          userResult.fold(
            (error) {
              log('❌ Failed to fetch user profile: $error', name: 'AuthCubit');
              if (!isClosed)
                emit(AuthError(message: 'failed_to_fetch_user_profile'.tr()));
            },
            (user) async {
              log('✅ User profile fetched: ${user.email}', name: 'AuthCubit');
              log('💾 Saving user session...', name: 'AuthCubit');

              // Save user info
              await _authService.saveUserSession(
                accessToken: response.accessToken,
                refreshToken: response.refreshToken,
                userId: user.id,
                email: user.email,
                name: user.name,
              );

              log('✅ Session saved successfully', name: 'AuthCubit');
              AuthErrorHandler.logAuthSuccess('Login', user.email);

              if (!isClosed) emit(Authenticated(user: user));
            },
          );
        },
      );
    } catch (e) {
      log('❌ Unexpected error during login: $e', name: 'AuthCubit');
      AuthErrorHandler.logAuthFailure('Login', request.email, e.toString());
      if (!isClosed) emit(AuthError(message: "unexpected_error".tr()));
    }
  }

  // Register
  Future<void> register(RegisterRequest request) async {
    if (isClosed) return; // Exit early if closed

    log('📝 Starting registration process...', name: 'AuthCubit');
    log(
      '📋 Registration data - UserName: ${request.userName}, Email: ${request.email}',
      name: 'AuthCubit',
    );
    AuthErrorHandler.logAuthAttempt('Registration', request.email);

    if (!isClosed) emit(const AuthLoading());

    try {
      log('📡 Sending registration request to API...', name: 'AuthCubit');
      log('🔑 Password length: ${request.password.length}', name: 'AuthCubit');
      log(
        '🔑 Password confirmation match: ${request.password == request.confirmPassword}',
        name: 'AuthCubit',
      );

      final result = await _authRepo.register(request);

      result.fold(
        (error) {
          log('❌ Registration API returned error: $error', name: 'AuthCubit');
          AuthErrorHandler.logAuthFailure('Registration', request.email, error);

          // Parse error message to get user-friendly text
          final errorMessage = _parseErrorMessage(error);
          log('🔴 Emitting error state: $errorMessage', name: 'AuthCubit');

          if (!isClosed) emit(AuthError(message: errorMessage));
        },
        (response) async {
          log(
            '✅ Registration successful: ${response.message}',
            name: 'AuthCubit',
          );
          log('🔐 Now logging in user automatically...', name: 'AuthCubit');
          AuthErrorHandler.logAuthSuccess('Registration', request.email);

          // After successful registration, automatically login the user
          await login(
            LoginRequest(email: request.email, password: request.password),
          );
        },
      );
    } catch (e) {
      log('❌ Unexpected error during registration: $e', name: 'AuthCubit');
      log('❌ Error type: ${e.runtimeType}', name: 'AuthCubit');
      AuthErrorHandler.logAuthFailure(
        'Registration',
        request.email,
        e.toString(),
      );
      if (!isClosed) emit(AuthError(message: "unexpected_error".tr()));
    }
  }

  // Refresh token
  Future<bool> _refreshToken() async {
    log('🔄 Starting token refresh...', name: 'AuthCubit');

    try {
      final refreshToken = await _authService.getRefreshToken();
      log(
        '🎫 Refresh token exists: ${refreshToken != null}',
        name: 'AuthCubit',
      );

      if (refreshToken == null) {
        log('❌ No refresh token available', name: 'AuthCubit');
        return false;
      }

      log('📡 Calling refresh token API...', name: 'AuthCubit');
      final result = await _authRepo.refreshToken(
        RefreshTokenRequest(refreshToken: refreshToken),
      );

      return result.fold(
        (error) {
          log('❌ Token refresh failed: $error', name: 'AuthCubit');
          return false;
        },
        (response) async {
          log('✅ Token refresh successful', name: 'AuthCubit');
          log('💾 Saving new tokens...', name: 'AuthCubit');

          // Save new tokens
          await _tokenService.saveTokens(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
          );

          log('✅ New tokens saved', name: 'AuthCubit');
          return true;
        },
      );
    } catch (e) {
      log('❌ Unexpected error during token refresh: $e', name: 'AuthCubit');
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    log('🚪 Starting logout process...', name: 'AuthCubit');

    try {
      final refreshToken = await _authService.getRefreshToken();
      log(
        '🎫 Refresh token exists: ${refreshToken != null}',
        name: 'AuthCubit',
      );

      if (refreshToken != null) {
        log('📡 Calling logout API...', name: 'AuthCubit');
        // Call logout API
        await _authRepo.logout(refreshToken);
        log('✅ Logout API call successful', name: 'AuthCubit');
      }

      log('🧹 Clearing local session...', name: 'AuthCubit');
      // Clear local session
      await _authService.clearUserSession();
      log('✅ Local session cleared', name: 'AuthCubit');

      if (!isClosed) emit(const Unauthenticated());
      log('✅ Logout completed successfully', name: 'AuthCubit');
    } catch (e) {
      log('❌ Error during logout: $e', name: 'AuthCubit');
      log('🧹 Clearing local session anyway...', name: 'AuthCubit');
      // Still clear local session even if API call fails
      await _authService.clearUserSession();
      if (!isClosed) emit(const Unauthenticated());
      log('✅ Logout completed (with API error)', name: 'AuthCubit');
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    log('🔐 Starting password change...', name: 'AuthCubit');
    log(
      '🔑 Current password length: ${currentPassword.length}',
      name: 'AuthCubit',
    );
    log('🔑 New password length: ${newPassword.length}', name: 'AuthCubit');
    log(
      '🔑 Passwords match: ${newPassword == newPasswordConfirmation}',
      name: 'AuthCubit',
    );

    try {
      final result = await _authRepo.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );

      result.fold(
        (error) {
          log('❌ Password change failed: $error', name: 'AuthCubit');
          if (!isClosed) emit(AuthError(message: _parseErrorMessage(error)));
        },
        (_) {
          log('✅ Password changed successfully', name: 'AuthCubit');
          // Keep current state (still authenticated)
        },
      );
    } catch (e) {
      log('❌ Unexpected error during password change: $e', name: 'AuthCubit');
      if (!isClosed)
        emit(AuthError(message: 'password_change_unexpected_error'.tr()));
    }
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
    log('👤 Starting profile update...', name: 'AuthCubit');
    log('📝 New name: $name', name: 'AuthCubit');
    log('📱 Phone: ${phone ?? "not provided"}', name: 'AuthCubit');

    try {
      final result = await _authRepo.updateProfile(name: name, phone: phone);

      result.fold(
        (error) {
          log('❌ Profile update failed: $error', name: 'AuthCubit');
          if (!isClosed) emit(AuthError(message: _parseErrorMessage(error)));
        },
        (updatedUser) async {
          log('✅ Profile updated successfully', name: 'AuthCubit');
          log('💾 Updating stored user info...', name: 'AuthCubit');

          // Update stored user info
          await _authService.saveUserSession(
            accessToken: await _authService.getAccessToken() ?? '',
            refreshToken: await _authService.getRefreshToken() ?? '',
            userId: updatedUser.id,
            email: updatedUser.email,
            name: updatedUser.name,
          );

          log('✅ User info updated in storage', name: 'AuthCubit');
          if (!isClosed) emit(Authenticated(user: updatedUser));
        },
      );
    } catch (e) {
      log('❌ Unexpected error during profile update: $e', name: 'AuthCubit');
      if (!isClosed)
        emit(AuthError(message: 'profile_update_unexpected_error'.tr()));
    }
  }

  // Parse error message from backend to user-friendly message
  String _parseErrorMessage(String error) {
    log('🔍 Parsing error message: $error', name: 'AuthCubit');

    // Convert error to lowercase for easier matching
    final errorLower = error.toLowerCase();

    // Check for "Invalid email or password" (Login error)
    if (errorLower.contains('invalid email or password')) {
      return 'Invalid_email_and_password'.tr();
    }

    // Username errors
    if (errorLower.contains('username') && errorLower.contains('required')) {
      return 'please_enter_username'.tr();
    }
    if (errorLower.contains('username') &&
        errorLower.contains('3 characters')) {
      return 'username_must_be_at_least_3_characters'.tr();
    }
    if (errorLower.contains('username') &&
        (errorLower.contains('letters') ||
            errorLower.contains('numbers') ||
            errorLower.contains('hyphens') ||
            errorLower.contains('underscores'))) {
      return 'username_invalid_characters'.tr();
    }
    if (errorLower.contains('username') && errorLower.contains('already')) {
      return 'username_already_in_use'.tr();
    }

    // Email errors
    if (errorLower.contains('email') && errorLower.contains('already')) {
      return AuthErrorHandler.getErrorMessage('email-already-in-use');
    }
    if (errorLower.contains('invalid') && errorLower.contains('email')) {
      return AuthErrorHandler.getErrorMessage('invalid-email');
    }
    if (errorLower.contains('email') && errorLower.contains('not found')) {
      return AuthErrorHandler.getErrorMessage('user-not-found');
    }

    // Password errors
    if (errorLower.contains('password') &&
        (errorLower.contains('wrong') || errorLower.contains('incorrect'))) {
      return AuthErrorHandler.getErrorMessage('wrong-password');
    }
    if (errorLower.contains('password') && errorLower.contains('weak')) {
      return AuthErrorHandler.getErrorMessage('weak-password');
    }
    if (errorLower.contains('password') && errorLower.contains('match')) {
      return 'passwords_mismatch'.tr();
    }

    // Account errors
    if (errorLower.contains('account') && errorLower.contains('disabled')) {
      return AuthErrorHandler.getErrorMessage('user-disabled');
    }
    if (errorLower.contains('user') && errorLower.contains('disabled')) {
      return AuthErrorHandler.getErrorMessage('user-disabled');
    }

    // Rate limiting
    if (errorLower.contains('too many') || errorLower.contains('rate limit')) {
      return AuthErrorHandler.getErrorMessage('too-many-requests');
    }

    // Network errors
    if (errorLower.contains('network') ||
        errorLower.contains('connection') ||
        errorLower.contains('timeout')) {
      return AuthErrorHandler.getErrorMessage('network-request-failed');
    }

    // Credential errors
    if (errorLower.contains('credential') ||
        errorLower.contains('unauthorized') ||
        errorLower.contains('authentication credentials')) {
      return 'invalid_credentials'.tr();
    }

    // User not found
    if (errorLower.contains('user') && errorLower.contains('not found')) {
      return 'user_not_found_error'.tr();
    }

    // Validation errors (Backend specific)
    if (errorLower.contains('validation') || errorLower.contains('required')) {
      return 'validation_error'.tr();
    }

    // Token errors
    if (errorLower.contains('token') &&
        (errorLower.contains('invalid') || errorLower.contains('expired'))) {
      return 'token_expired'.tr();
    }

    // Server errors
    if (errorLower.contains('server') || errorLower.contains('500')) {
      return 'server_error'.tr();
    }

    // 401 Unauthorized
    if (error.contains('401')) {
      return 'unauthorized_access'.tr();
    }

    // 404 Not Found
    if (error.contains('404')) {
      return 'not_found_error'.tr();
    }

    // 422 Unprocessable Entity
    if (error.contains('422')) {
      return 'invalid_data_error'.tr();
    }

    // Default: return the original error if we can't parse it
    log(
      '⚠️ Unable to parse error, returning original message',
      name: 'AuthCubit',
    );
    return error.isNotEmpty
        ? error
        : AuthErrorHandler.getErrorMessage('unknown-error');
  }
}
