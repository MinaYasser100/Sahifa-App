import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class TextSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const TextSearchBar({super.key, required this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      color: isDarkMode
          ? ColorsTheme().primaryDark
          : ColorsTheme().primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: controller,
            hintText: 'search_placeholder'.tr(),
            ischangeColor: true,
            keyboardType: TextInputType.text,
            onChanged: onChanged,
            validator: (p0) {
              return null;
            },
          ),
        ),
      ),
    );
  }
}
