import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/routing/routes.dart';
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
          'already_have_an_account'.tr(),
          style: AppTextStyles.styleRegular14sp(
            context,
          ).copyWith(color: ColorsTheme().primaryLight),
        ),
        TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            minimumSize: const Size(50, 30),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft,
          ),
          onPressed: () {
            context.push(Routes.loginView);
          },
          child: Text(
            'login'.tr(),
            style: AppTextStyles.styleBold18sp(context),
          ),
        ),
      ],
    );
  }
}
