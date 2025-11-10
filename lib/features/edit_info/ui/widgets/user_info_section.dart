import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class UserInfoSection extends StatelessWidget {
  final TextEditingController userNameController;
  final TextEditingController aboutMeController;

  const UserInfoSection({
    super.key,
    required this.userNameController,
    required this.aboutMeController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User Name
        Text(
          '${'username'.tr()}:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: userNameController,
            hintText: 'enter_username'.tr(),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'username_cannot_be_empty'.tr();
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),

        // About Me
        Text(
          '${'about_me'.tr()}:',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: aboutMeController,
            hintText: 'enter_about_me'.tr(),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            validator: (value) => null,
          ),
        ),
      ],
    );
  }
}
