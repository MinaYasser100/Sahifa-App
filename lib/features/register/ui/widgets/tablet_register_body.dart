import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
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
                      text: 'register'.tr(),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          // Handle register logic here
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
  }
}
