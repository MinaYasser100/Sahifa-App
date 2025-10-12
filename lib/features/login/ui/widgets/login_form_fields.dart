import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/validation/validatoin.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/register/ui/widgets/custom_field_with_title.dart';

class LoginFormFields extends StatelessWidget {
  const LoginFormFields({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
    required this.passwordController,
    required this.passwordFocusNode,
  });

  final TextEditingController emailController;
  final FocusNode emailFocusNode;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              autofocus: true,
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
            ),
          ),
        ),
      ],
    );
  }
}
