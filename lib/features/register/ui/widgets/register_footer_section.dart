import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class RegisterFooterSection extends StatelessWidget {
  const RegisterFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.styleRegular14sp(
            context,
          ).copyWith(color: ColorsTheme().grayColor),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Login',
            style: AppTextStyles.styleBold14sp(
              context,
            ).copyWith(color: ColorsTheme().secondaryColor),
          ),
        ),
      ],
    );
  }
}
