import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';

/// Helper class to handle Firebase Authentication errors and convert them to user-friendly messages
class AuthErrorHandler {
  /// Convert Firebase Auth error code to localized message
  static String getErrorMessage(String errorCode) {
    log('🔐 Auth Error Code: $errorCode', name: 'AuthErrorHandler');

    switch (errorCode) {
      // Email/Password Registration Errors
      case 'email-already-in-use':
        log(
          '❌ Registration failed: Email already exists',
          name: 'AuthErrorHandler',
        );
        return 'auth_email_already_in_use_description'.tr();

      case 'invalid-email':
        log('❌ Invalid email format provided', name: 'AuthErrorHandler');
        return 'auth_invalid_email_description'.tr();

      case 'operation-not-allowed':
        log(
          '❌ Email/Password authentication is disabled',
          name: 'AuthErrorHandler',
        );
        return 'auth_operation_not_allowed_description'.tr();

      case 'weak-password':
        log('❌ Password is too weak', name: 'AuthErrorHandler');
        return 'auth_weak_password_description'.tr();

      // Login Errors
      case 'user-not-found':
        log('❌ No user found with this email', name: 'AuthErrorHandler');
        return 'auth_user_not_found_description'.tr();

      case 'wrong-password':
        log('❌ Incorrect password provided', name: 'AuthErrorHandler');
        return 'auth_wrong_password_description'.tr();

      case 'user-disabled':
        log('❌ User account has been disabled', name: 'AuthErrorHandler');
        return 'auth_user_disabled_description'.tr();

      // Rate Limiting
      case 'too-many-requests':
        log(
          '⚠️ Too many failed attempts, temporarily blocked',
          name: 'AuthErrorHandler',
        );
        return 'auth_too_many_requests_description'.tr();

      // Network Errors
      case 'network-request-failed':
        log(
          '❌ Network error: No internet connection',
          name: 'AuthErrorHandler',
        );
        return 'auth_network_request_failed_description'.tr();

      // Credential Errors
      case 'invalid-credential':
        log('❌ Invalid credentials provided', name: 'AuthErrorHandler');
        return 'auth_invalid_credential_description'.tr();

      case 'account-exists-with-different-credential':
        log(
          '⚠️ Account exists with different sign-in method',
          name: 'AuthErrorHandler',
        );
        return 'auth_account_exists_with_different_credential_description'.tr();

      // Session Errors
      case 'requires-recent-login':
        log(
          '⚠️ Sensitive operation requires recent authentication',
          name: 'AuthErrorHandler',
        );
        return 'auth_requires_recent_login_description'.tr();

      // Default Unknown Error
      default:
        log('❌ Unknown auth error: $errorCode', name: 'AuthErrorHandler');
        return 'auth_unknown_error_description'.tr();
    }
  }

  /// Get error title for dialog/snackbar
  static String getErrorTitle(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'auth_email_already_in_use'.tr();
      case 'invalid-email':
        return 'auth_invalid_email'.tr();
      case 'operation-not-allowed':
        return 'auth_operation_not_allowed'.tr();
      case 'weak-password':
        return 'auth_weak_password'.tr();
      case 'user-not-found':
        return 'auth_user_not_found'.tr();
      case 'wrong-password':
        return 'auth_wrong_password'.tr();
      case 'user-disabled':
        return 'auth_user_disabled'.tr();
      case 'too-many-requests':
        return 'auth_too_many_requests'.tr();
      case 'network-request-failed':
        return 'auth_network_request_failed'.tr();
      case 'invalid-credential':
        return 'auth_invalid_credential'.tr();
      case 'account-exists-with-different-credential':
        return 'auth_account_exists_with_different_credential'.tr();
      case 'requires-recent-login':
        return 'auth_requires_recent_login'.tr();
      default:
        return 'auth_unknown_error'.tr();
    }
  }

  /// Log authentication attempt
  static void logAuthAttempt(String action, String email) {
    log(
      '🔑 Auth Attempt: $action for email: ${_maskEmail(email)}',
      name: 'AuthErrorHandler',
    );
  }

  /// Log successful authentication
  static void logAuthSuccess(String action, String email) {
    log(
      '✅ Auth Success: $action for email: ${_maskEmail(email)}',
      name: 'AuthErrorHandler',
    );
  }

  /// Log authentication failure
  static void logAuthFailure(String action, String email, String error) {
    log(
      '❌ Auth Failure: $action for email: ${_maskEmail(email)} - Error: $error',
      name: 'AuthErrorHandler',
    );
  }

  /// Mask email for privacy in logs (shows first 2 chars + domain)
  static String _maskEmail(String email) {
    if (email.isEmpty) return '***';

    final parts = email.split('@');
    if (parts.length != 2) return '***@***';

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) {
      return '$username***@$domain';
    }

    return '${username.substring(0, 2)}***@$domain';
  }
}
