import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class LoginFooterSection extends StatelessWidget {
  const LoginFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account? ',
          style: AppTextStyles.styleRegular16sp(
            context,
          ).copyWith(color: ColorsTheme().primaryLight.withValues(alpha: 0.7)),
        ),
        GestureDetector(
          onTap: () {
            context.pop();
          },
          child: Text(
            'Register',
            style: AppTextStyles.styleBold18sp(
              context,
            ).copyWith(color: ColorsTheme().primaryColor),
          ),
        ),
      ],
    );
  }
}
