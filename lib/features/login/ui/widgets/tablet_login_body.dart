import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/features/login/ui/widgets/login_footer_section.dart';
import 'package:sahifa/features/login/ui/widgets/login_form_fields.dart';
import 'package:sahifa/features/login/ui/widgets/login_header_section.dart';

class TabletLoginBody extends StatelessWidget {
  const TabletLoginBody({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AutovalidateModeCubit, AutovalidateModeState>(
      builder: (context, state) {
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Form(
                key: formKey,
                autovalidateMode: context
                    .watch<AutovalidateModeCubit>()
                    .autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LoginHeaderSection(),
                    LoginFormFields(
                      emailController: emailController,
                      emailFocusNode: emailFocusNode,
                      passwordController: passwordController,
                      passwordFocusNode: passwordFocusNode,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.push(Routes.forgotPasswordView);
                          },
                          child: Text('forgot_password'.tr()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'login'.tr(),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Handle login logic here
                        } else {
                          context
                              .read<AutovalidateModeCubit>()
                              .changeAutovalidateMode();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    const LoginFooterSection(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
