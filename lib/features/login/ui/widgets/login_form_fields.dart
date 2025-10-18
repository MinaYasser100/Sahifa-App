import 'package:easy_localization/easy_localization.dart';
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
          title: 'email_address'.tr(),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'email_address'.tr(),
              validator: Validation.emailValidation,
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
          title: 'password'.tr(),
          child: CustomTextFormField(
            textFieldModel: TextFieldModel(
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              hintText: 'password'.tr(),
              validator: Validation.validatePassword,
              obscureText: true,
              focusNode: passwordFocusNode,
            ),
          ),
        ),
      ],
    );
  }
}
