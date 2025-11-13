import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/routing/routes.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/features/auth/data/models/register_request.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:sahifa/features/register/ui/widgets/register_footer_section.dart';
import 'package:sahifa/features/register/ui/widgets/register_form_fields.dart';
import 'package:sahifa/features/register/ui/widgets/register_header_section.dart';

class TabletRegisterBody extends StatelessWidget {
  const TabletRegisterBody({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.fullNameFocusNode,
    required this.emailFocusNode,
    required this.emailController,
    required this.passwordFocusNode,
    required this.passwordController,
    required this.confirmPasswordFocusNode,
    required this.confirmPasswordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final FocusNode fullNameFocusNode;
  final FocusNode emailFocusNode;
  final TextEditingController emailController;
  final FocusNode passwordFocusNode;
  final TextEditingController passwordController;
  final FocusNode confirmPasswordFocusNode;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          // After successful registration, go directly to home
          showSuccessToast(
            context,
            'success'.tr(),
            'registration_successful'.tr(),
          );
          context.go(Routes.layoutView);
        } else if (state is AuthError) {
          showErrorToast(context, 'error'.tr(), state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
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
                        const RegisterHeaderSection(),
                        RegisterFormFields(
                          fullNameController: fullNameController,
                          fullNameFocusNode: fullNameFocusNode,
                          emailController: emailController,
                          emailFocusNode: emailFocusNode,
                          passwordController: passwordController,
                          passwordFocusNode: passwordFocusNode,
                          confirmPasswordController: confirmPasswordController,
                          confirmPasswordFocusNode: confirmPasswordFocusNode,
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'create_account'.tr(),
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    final request = RegisterRequest(
                                      userName: fullNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                      confirmPassword: confirmPasswordController
                                          .text
                                          .trim(),
                                    );
                                    context.read<AuthCubit>().register(request);
                                  } else {
                                    context
                                        .read<AutovalidateModeCubit>()
                                        .changeAutovalidateMode();
                                  }
                                },
                        ),
                        const SizedBox(height: 16),
                        const RegisterFooterSection(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
