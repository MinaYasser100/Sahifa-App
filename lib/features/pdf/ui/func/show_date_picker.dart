import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

Future<void> showDatePickerMethod(
  BuildContext context,
  DateTime currentDate,
  Function(DateTime) onDateSelected,
) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    locale: context.locale,
    builder: (context, child) {
      final isDarkMode = Theme.of(context).brightness == Brightness.dark;
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: ColorsTheme().primaryColor,
            onPrimary: ColorsTheme().whiteColor,
            surface: isDarkMode
                ? ColorsTheme().cardColor
                : ColorsTheme().whiteColor,
            onSurface: isDarkMode
                ? ColorsTheme().whiteColor
                : ColorsTheme().blackColor,
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null && picked != currentDate) {
    onDateSelected(picked);
  }
}
