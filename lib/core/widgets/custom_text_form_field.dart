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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Determine colors based on mode
    final Color textColor = widget.textFieldModel.readOnly
        ? ColorsTheme().grayColor
        : (isDarkMode ? ColorsTheme().whiteColor : ColorsTheme().primaryColor);

    final Color cursorColor = (isDarkMode
        ? ColorsTheme().whiteColor
        : ColorsTheme().primaryColor);

    final Color hintColor = isDarkMode
        ? ColorsTheme().grayColor.withValues(alpha: 0.6)
        : ColorsTheme().grayColor;

    final Color labelColor = widget.textFieldModel.ischangeColor
        ? (isDarkMode ? ColorsTheme().primaryLight : ColorsTheme().primaryColor)
        : ColorsTheme().primaryColor;

    final Color iconColor = widget.textFieldModel.ischangeColor
        ? (isDarkMode ? ColorsTheme().primaryLight : ColorsTheme().primaryColor)
        : (isDarkMode ? ColorsTheme().whiteColor : ColorsTheme().grayColor);

    final Color borderColor = (isDarkMode
        ? ColorsTheme().primaryLight
        : ColorsTheme().grayColor);

    return TextFormField(
      controller: widget.textFieldModel.controller,
      cursorColor: cursorColor,
      validator: widget.textFieldModel.validator,
      autovalidateMode: widget.textFieldModel.autovalidateMode,
      obscureText: isObscured,
      keyboardType: widget.textFieldModel.keyboardType,
      autofocus: widget.textFieldModel.autofocus,
      focusNode: widget.textFieldModel.focusNode,
      onFieldSubmitted: widget.textFieldModel.onFieldSubmitted,
      onChanged: widget.textFieldModel.onChanged,
      style: TextStyle(color: textColor, fontSize: 18),
      readOnly: widget.textFieldModel.readOnly,
      maxLines: widget.textFieldModel.maxLines,
      onTap: widget.textFieldModel.onTap,
      decoration: InputDecoration(
        labelText: widget.textFieldModel.labelText,
        hintText: widget.textFieldModel.hintText,
        errorText: widget.textFieldModel.errorText,
        hintStyle: TextStyle(color: hintColor),
        labelStyle: TextStyle(color: labelColor),
        prefixIcon: widget.textFieldModel.icon != null
            ? Icon(widget.textFieldModel.icon, color: iconColor)
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
                      ? (isDarkMode
                            ? ColorsTheme().primaryLight
                            : ColorsTheme().primaryColor)
                      : ColorsTheme().secondaryColor,
                ),
              )
            : null,
        border: _customOutlineInputBorder(borderColor),
        focusedBorder: _customOutlineInputBorder(
          isDarkMode ? ColorsTheme().whiteColor : ColorsTheme().primaryColor,
        ),
        enabledBorder: _customOutlineInputBorder(borderColor),
        errorBorder: _customOutlineInputBorder(ColorsTheme().errorColor),
        focusedErrorBorder: _customOutlineInputBorder(ColorsTheme().errorColor),
      ),
    );
  }

  OutlineInputBorder _customOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color),
    );
  }
}
