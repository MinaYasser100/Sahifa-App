import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class TextSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const TextSearchBar({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: CustomTextFormField(
        textFieldModel: TextFieldModel(
          controller: controller,
          hintText: 'search_placeholder'.tr(),
          keyboardType: TextInputType.text,
          onChanged: onChanged,
          validator: (p0) {
            return null;
          },
        ),
      ),
    );
  }
}
