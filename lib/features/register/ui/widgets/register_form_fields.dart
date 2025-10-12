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
          title: 'Full Name',
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: fullNameController,
              keyboardType: TextInputType.name,
              hintText: 'Full Name',
              validator: Validatoin.validateFullName,
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
          title: 'Email Address',
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Email Address',
              validator: Validatoin.emailValidation,
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
          title: 'Password',
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Password',
              validator: Validatoin.validatePassword,
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
          title: 'Confirm Password',
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: confirmPasswordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'Confirm Password',
              validator: (value) =>
                  Validatoin.validateConfirmPassword(value, passwordController),
              obscureText: true,
              focusNode: confirmPasswordFocusNode,
            ),
          ),
        ),
      ],
    );
  }
}
