import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';

Future<void> showDatePickerMethod(
  BuildContext context,
  DateTime currentDate,
  Function(DateTime) onDateSelected,
) async {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
    locale: context.locale,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: isDarkMode
              ? ColorScheme.dark(
                  primary: ColorsTheme().grayColor,
                  onPrimary: ColorsTheme().whiteColor,
                  surface: ColorsTheme().primaryDark,
                  onSurface: ColorsTheme().whiteColor,
                )
              : ColorScheme.light(
                  primary: ColorsTheme().primaryColor,
                  onPrimary: ColorsTheme().whiteColor,
                  surface: ColorsTheme().whiteColor,
                  onSurface: ColorsTheme().blackColor,
                ), dialogTheme: DialogThemeData(backgroundColor: isDarkMode
              ? ColorsTheme().cardColor
              : ColorsTheme().whiteColor),
        ),
        child: child!,
      );
    },
  );

  // Call the callback with the selected date if user didn't cancel
  if (pickedDate != null) {
    onDateSelected(pickedDate);
  } else {
    showErrorToast(context, 'error'.tr(), 'date_selection_cancelled'.tr());
  }
}
