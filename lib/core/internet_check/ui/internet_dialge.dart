import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

void showNoInternetDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent dialog from being dismissed
    builder: (_) => AlertDialog(
      backgroundColor: ColorsTheme().whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      insetPadding: const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
      content: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 60,
              color: ColorsTheme().errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'no_internet'.tr(),
              style: AppTextStyles.styleBold22sp(
                context,
              ).copyWith(color: ColorsTheme().errorColor),
            ),
            const SizedBox(height: 12),
            Text(
              'please_check_your_internet_connection'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: ColorsTheme().primaryDark, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: ColorsTheme().primaryColor,
                    side: BorderSide(color: ColorsTheme().primaryLight),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('cancel'.tr()),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
