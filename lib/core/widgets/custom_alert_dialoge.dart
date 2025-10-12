import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

import '../theme/app_style.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String nameOfPositiveButton;
  final String nameOfNegativeButton;
  final VoidCallback? onPositiveButtonPressed;
  final VoidCallback? onNegativeButtonPressed;
  final bool? isLoading;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.onPositiveButtonPressed,
    this.onNegativeButtonPressed,
    required this.nameOfPositiveButton,
    required this.nameOfNegativeButton,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorsTheme().primaryColor,
      title: Text(
        title,
        style: AppTextStyles.styleMedium24sp(
          context,
        ).copyWith(color: ColorsTheme().whiteColor),
      ),
      content: Text(
        content,
        style: AppTextStyles.styleRegular18sp(
          context,
        ).copyWith(color: ColorsTheme().whiteColor),
      ),

      actions: [
        Container(
          color: ColorsTheme().primaryColor,
          child: TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: ColorsTheme().primaryLight, width: 2),
              ),
              backgroundColor: ColorsTheme().whiteColor,
            ),
            onPressed: onNegativeButtonPressed,
            child: Text(
              nameOfNegativeButton,
              style: AppTextStyles.styleBold18sp(
                context,
              ).copyWith(color: ColorsTheme().primaryColor),
            ),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: ColorsTheme().primaryLight, width: 2),
            ),
            backgroundColor: ColorsTheme().whiteColor,
          ),
          onPressed: onPositiveButtonPressed,
          child: isLoading!
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  nameOfPositiveButton,
                  style: AppTextStyles.styleBold18sp(
                    context,
                  ).copyWith(color: ColorsTheme().primaryColor),
                ),
        ),
      ],
    );
  }
}
