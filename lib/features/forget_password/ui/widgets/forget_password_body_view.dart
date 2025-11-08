import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/manager/autovalidate_mode/autovalidate_mode_cubit.dart';
import 'package:sahifa/core/widgets/custom_button.dart';
import 'package:sahifa/features/forget_password/ui/widgets/forget_password_form_field.dart';
import 'package:sahifa/features/forget_password/ui/widgets/forget_password_header_section.dart';

class ForgetPasswordBodyView extends StatelessWidget {
  const ForgetPasswordBodyView({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.emailFocusNode,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final FocusNode emailFocusNode;

  @override
  Widget build(BuildContext context) {
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
                const ForgetPasswordHeaderSection(),

                // Form Field Section
                ForgetPasswordFormField(
                  emailController: emailController,
                  emailFocusNode: emailFocusNode,
                ),

                const SizedBox(height: 32),

                // Send Reset Link Button
                CustomButton(
                  text: 'forgot_password'.tr(),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      // Handle forget password logic here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('reset_link_sent_to_your_email'.tr()),
                        ),
                      );
                    } else {
                      context
                          .read<AutovalidateModeCubit>()
                          .changeAutovalidateMode();
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Back to Login
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'login'.tr(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
