import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';

class CustomFieldWithTitle extends StatelessWidget {
  const CustomFieldWithTitle({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(title, style: AppTextStyles.styleMedium16sp(context)),
        ),
        child,
      ],
    );
  }
}
