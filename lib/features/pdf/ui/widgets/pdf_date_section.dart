import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/pdf/ui/func/show_date_picker.dart';

class PdfDateSection extends StatelessWidget {
  const PdfDateSection({
    super.key,
    required this.currentDate,
    required this.onDateSelected,
    required this.isDarkMode,
  });

  final DateTime currentDate;
  final Function(DateTime) onDateSelected;
  final bool isDarkMode;

  // Constants
  static const double _containerPaddingHorizontal = 12.0;
  static const double _containerPaddingVertical = 8.0;
  static const double _borderRadius = 8.0;
  static const double _borderWidth = 1.0;
  static const double _bgOpacityDark = 0.15;
  static const double _bgOpacityLight = 0.08;
  static const double _borderOpacityDark = 0.3;
  static const double _borderOpacityLight = 0.2;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          showDatePickerMethod(context, currentDate, onDateSelected);
        },
        child: FadeInDown(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: _containerPaddingHorizontal,
              vertical: _containerPaddingVertical,
            ),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? ColorsTheme().primaryLight.withValues(alpha: _bgOpacityDark)
                  : ColorsTheme().primaryColor.withValues(
                      alpha: _bgOpacityLight,
                    ),
              borderRadius: BorderRadius.circular(_borderRadius),
              border: Border.all(
                color: isDarkMode
                    ? ColorsTheme().primaryLight.withValues(
                        alpha: _borderOpacityDark,
                      )
                    : ColorsTheme().primaryColor.withValues(
                        alpha: _borderOpacityLight,
                      ),
                width: _borderWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd/MM/yyyy').format(currentDate),
                  style: AppTextStyles.styleMedium14sp(context).copyWith(
                    color: isDarkMode
                        ? ColorsTheme().secondaryLight
                        : ColorsTheme().primaryColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_drop_down,
                  size: 24,
                  color: isDarkMode
                      ? ColorsTheme().secondaryLight
                      : ColorsTheme().primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
