import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/validation/validatoin.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/register/ui/widgets/custom_field_with_title.dart';

class RegisterFormFields extends StatelessWidget {
  const RegisterFormFields({
    super.key,
    required this.fullNameController,
    required this.fullNameFocusNode,
    required this.emailFocusNode,
    required this.emailController,
    required this.passwordFocusNode,
    required this.passwordController,
    required this.confirmPasswordFocusNode,
    required this.confirmPasswordController,
  });

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Full Name Field
        CustomFieldWithTitle(
          title: 'full_name'.tr(),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: fullNameController,
              keyboardType: TextInputType.name,
              hintText: 'full_name'.tr(),
              validator: Validation.validateFullName,
              focusNode: fullNameFocusNode,
              autofocus: true,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(emailFocusNode);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Email Field
        CustomFieldWithTitle(
          title: 'email_address'.tr(),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'email_address'.tr(),
              validator: Validation.emailValidation,
              focusNode: emailFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Password Field
        CustomFieldWithTitle(
          title: 'password'.tr(),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'password'.tr(),
              validator: Validation.validatePassword,
              obscureText: true,
              focusNode: passwordFocusNode,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(confirmPasswordFocusNode);
              },
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Confirm Password Field
        CustomFieldWithTitle(
          title: 'confirm_password'.tr(),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'confirm_password'.tr(),
              validator: (value) =>
                  Validation.validateConfirmPassword(value, passwordController),
              obscureText: true,
              focusNode: confirmPasswordFocusNode,
            ),
          ),
        ),
      ],
    );
  }
}
