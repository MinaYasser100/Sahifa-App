import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';

class LogoutDialogWidget extends StatelessWidget {
  const LogoutDialogWidget({
    super.key,
    required this.isDark,
    required this.colors,
  });

  final bool isDark;
  final ColorsTheme colors;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: isDark ? colors.cardColor : colors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Column(
        children: [
          Icon(Icons.logout, size: 60, color: colors.errorColor),
          const SizedBox(height: 16),
          Text(
            'logout'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? colors.whiteColor : colors.primaryDark,
            ),
          ),
        ],
      ),
      content: Text(
        'are_you_sure_logout'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: isDark ? colors.softBlue : colors.grayColor,
        ),
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isDark
                      ? colors.softBlue
                      : colors.primaryColor,
                  side: BorderSide(
                    color: isDark ? colors.softBlue : colors.primaryColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'cancel'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  // Call logout from AuthCubit
                  await context.read<AuthCubit>().logout();

                  // Navigate to login screen and remove all previous routes
                  if (context.mounted) {
                    context.go(Routes.loginView);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.errorColor,
                  foregroundColor: colors.whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'logout'.tr(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
