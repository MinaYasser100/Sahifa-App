import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';

class MyFavoritesUnauthenticatedWidget extends StatelessWidget {
  const MyFavoritesUnauthenticatedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              Icons.favorite_border_rounded,
              size: 120,
              color: ColorsTheme().primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              'login_required'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: ColorsTheme().primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              'login_to_see_favorites'.tr(),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Login Button
            ElevatedButton.icon(
              onPressed: () {
                context.go(Routes.loginView);
              },
              icon: const Icon(Icons.login),
              label: Text('go_to_login'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsTheme().primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
