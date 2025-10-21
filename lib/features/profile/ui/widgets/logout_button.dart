import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

import 'logout_dialog_widget.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = ColorsTheme();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () {
          _showLogoutDialog(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.errorColor,
          foregroundColor: colors.whiteColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
            const SizedBox(width: 8),
            Text(
              'logout'.tr(),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final colors = ColorsTheme();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => LogoutDialogWidget(isDark: isDark, colors: colors),
    );
  }
}
