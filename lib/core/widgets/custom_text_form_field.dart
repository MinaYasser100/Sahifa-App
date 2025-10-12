import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/utils/colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({super.key, required this.textFieldModel});

  final TextFieldModel textFieldModel;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isObscured;

  @override
  void initState() {
    super.initState();
    isObscured = widget.textFieldModel.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textFieldModel.controller,
      cursorColor: ColorsTheme().primaryDark,
      validator: widget.textFieldModel.validator,
      autovalidateMode: widget.textFieldModel.autovalidateMode,
      obscureText: isObscured,
      keyboardType: widget.textFieldModel.keyboardType,
      autofocus: widget.textFieldModel.autofocus,
      focusNode: widget.textFieldModel.focusNode,
      onFieldSubmitted: widget.textFieldModel.onFieldSubmitted,
      onChanged: widget.textFieldModel.onChanged,
      style: TextStyle(color: ColorsTheme().primaryDark),
      decoration: InputDecoration(
        labelText: widget.textFieldModel.labelText,
        hintText: widget.textFieldModel.hintText,
        errorText: widget.textFieldModel.errorText,
        hintStyle: TextStyle(color: ColorsTheme().grayColor),
        labelStyle: TextStyle(color: ColorsTheme().primaryDark),
        prefixIcon: Icon(
          widget.textFieldModel.icon,
          size: 22,
          color: ColorsTheme().primaryDark,
        ),
        prefixIconConstraints: const BoxConstraints(
          minHeight: 40, // علشان الأيقونة تبقى في النص
          minWidth: 40,
        ),
        suffixIcon: widget.textFieldModel.obscureText
            ? GestureDetector(
                onTap: () {
                  isObscured = !isObscured;
                  setState(() {});
                },
                child: Icon(
                  isObscured ? Icons.visibility_off : Icons.visibility,
                  color: isObscured
                      ? ColorsTheme().primaryDark
                      : ColorsTheme().secondaryColor,
                ),
              )
            : null,
        border: _customOutlineInputBorder(),
        focusedBorder: _customOutlineInputBorder(),
        enabledBorder: _customOutlineInputBorder(),
      ),
    );
  }

  OutlineInputBorder _customOutlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: ColorsTheme().primaryDark),
    );
  }
}
