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
      cursorColor: widget.textFieldModel.ischangeColor
          ? ColorsTheme().grayColor
          : ColorsTheme().primaryColor,
      validator: widget.textFieldModel.validator,
      autovalidateMode: widget.textFieldModel.autovalidateMode,
      obscureText: isObscured,
      keyboardType: widget.textFieldModel.keyboardType,
      autofocus: widget.textFieldModel.autofocus,
      focusNode: widget.textFieldModel.focusNode,
      onFieldSubmitted: widget.textFieldModel.onFieldSubmitted,
      onChanged: widget.textFieldModel.onChanged,
      style: TextStyle(
        color: widget.textFieldModel.readOnly
            ? ColorsTheme().grayColor
            : (widget.textFieldModel.ischangeColor
                  ? ColorsTheme().grayColor
                  : ColorsTheme().whiteColor),
        fontSize: 18,
      ),
      readOnly: widget.textFieldModel.readOnly,
      maxLines: widget.textFieldModel.maxLines,
      onTap: widget.textFieldModel.onTap,
      decoration: InputDecoration(
        labelText: widget.textFieldModel.labelText,
        hintText: widget.textFieldModel.hintText,
        errorText: widget.textFieldModel.errorText,
        hintStyle: TextStyle(color: ColorsTheme().grayColor),
        labelStyle: TextStyle(color: ColorsTheme().primaryColor),
        prefixIcon: widget.textFieldModel.icon != null
            ? Icon(
                widget.textFieldModel.icon,
                color: widget.textFieldModel.ischangeColor
                    ? ColorsTheme().primaryColor
                    : ColorsTheme().grayColor,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
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
                      ? ColorsTheme().primaryColor
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
      borderSide: BorderSide(
        color: widget.textFieldModel.ischangeColor
            ? ColorsTheme().grayColor
            : ColorsTheme().primaryColor,
      ),
    );
  }
}
