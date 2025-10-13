import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class TextSearchBar extends StatelessWidget {
  final TextEditingController controller;
  const TextSearchBar({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: ColorsTheme().primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomTextFormField(
          textFieldModel: TextFieldModel(
            controller: controller,
            hintText: 'Search...',
            ischangeColor: true,
            keyboardType: TextInputType.text,
            validator: (p0) {
              return null;
            },
          ),
        ),
      ),
    );
  }
}
