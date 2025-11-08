import 'package:easy_localization/easy_localization.dart';
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
          'forgot_password'.tr(),
          style: AppTextStyles.styleBold18sp(
            context,
          ).copyWith(color: ColorsTheme().primaryColor),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'enter_your_email'.tr(),
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
