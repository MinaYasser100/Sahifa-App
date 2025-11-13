import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/features/auth/data/models/login_request.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:sahifa/features/login/ui/widgets/login_footer_section.dart';
import 'package:sahifa/features/login/ui/widgets/login_form_fields.dart';
import 'package:sahifa/features/login/ui/widgets/login_header_section.dart';

class LoginBodyView extends StatelessWidget {
  const LoginBodyView({
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is Authenticated) {
          showSuccessToast(context, 'success'.tr(), 'login_successful'.tr());
          context.go(Routes.layoutView);
        } else if (authState is AuthError) {
          showErrorToast(context, 'error'.tr(), authState.message);
        }
      },
      builder: (context, authState) {
        final isLoading = authState is AuthLoading;

        return BlocBuilder<AutovalidateModeCubit, AutovalidateModeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: formKey,
                autovalidateMode: context
                    .watch<AutovalidateModeCubit>()
                    .autovalidateMode,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    const LoginHeaderSection(),

                    // Form Fields Section
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

                    // Login Button
                    CustomButton(
                      text: 'login'.tr(),
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                final request = LoginRequest(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                                context.read<AuthCubit>().login(request);
                              } else {
                                context
                                    .read<AutovalidateModeCubit>()
                                    .changeAutovalidateMode();
                              }
                            },
                    ),

                    const SizedBox(height: 16),

                    // Footer Section
                    const LoginFooterSection(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
