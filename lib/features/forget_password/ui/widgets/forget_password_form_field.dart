import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/validation/validatoin.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';
import 'package:sahifa/features/register/ui/widgets/custom_field_with_title.dart';

class ForgetPasswordFormField extends StatelessWidget {
  const ForgetPasswordFormField({
    super.key,
    required this.emailController,
    required this.emailFocusNode,
  });

  final TextEditingController emailController;
  final FocusNode emailFocusNode;

  @override
  Widget build(BuildContext context) {
    return CustomFieldWithTitle(
      title: 'Email Address',
      child: CustomTextFormField(
        textFieldModel: TextFieldModel(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'Email Address',
          validator: Validatoin.emailValidation,
          focusNode: emailFocusNode,
          autofocus: true,
        ),
      ),
    );
  }
}
