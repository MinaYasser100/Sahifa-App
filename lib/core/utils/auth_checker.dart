// lib/core/utils/auth_checker.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/services/auth_service.dart';

class AuthChecker {
  /// Check if user is logged in, if not navigate to login
  /// Returns true if logged in, false if not
  static Future<bool> checkAuthAndNavigate(BuildContext context) async {
    final isLoggedIn = await AuthService().isLoggedIn();

    if (!isLoggedIn) {
      if (context.mounted) {
        // Navigate to login
        context.push(Routes.loginView);
      }
      return false;
    }

    return true;
  }

  /// Check if user is logged in without navigation
  static Future<bool> isLoggedIn() async {
    return await AuthService().isLoggedIn();
  }

  /// Show login required dialog
  static Future<bool> showLoginRequiredDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الدخول مطلوب'),
        content: const Text('يجب تسجيل الدخول أولاً للقيام بهذا الإجراء'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
              context.push(Routes.loginView);
            },
            child: const Text('تسجيل الدخول'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
