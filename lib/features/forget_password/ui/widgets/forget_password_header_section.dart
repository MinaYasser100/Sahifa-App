import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class ForgetPasswordHeaderSection extends StatelessWidget {
  const ForgetPasswordHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.lock_reset, size: 80, color: ColorsTheme().primaryColor),
        const SizedBox(height: 24),
        Text(
          'Forgot Password?',
          style: AppTextStyles.styleBold18sp(
            context,
          ).copyWith(color: ColorsTheme().primaryColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password',
          style: AppTextStyles.styleRegular14sp(
            context,
          ).copyWith(color: ColorsTheme().grayColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
