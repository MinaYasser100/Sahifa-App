import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, this.onPressed});
  final String text;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsTheme().primaryDark,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      ),
      onPressed: onPressed,
      child: Text(text, style: AppTextStyles.styleBold16sp(context)),
    );
  }
}
