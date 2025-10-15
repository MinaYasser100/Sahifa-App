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
  final Function(DateTime p1) onDateSelected;
  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => showDatePickerMethod(context, currentDate, onDateSelected),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDarkMode
                ? ColorsTheme().primaryLight.withValues(alpha: 0.15)
                : ColorsTheme().primaryColor.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode
                  ? ColorsTheme().primaryLight.withValues(alpha: 0.3)
                  : ColorsTheme().primaryColor.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 8),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'date'.toUpperCase(),
                      style: AppTextStyles.styleMedium12sp(context).copyWith(
                        color: isDarkMode
                            ? ColorsTheme().whiteColor.withValues(alpha: 0.7)
                            : ColorsTheme().primaryColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('dd/MM/yyyy').format(currentDate),
                      style: AppTextStyles.styleMedium14sp(context).copyWith(
                        color: isDarkMode
                            ? ColorsTheme().secondaryLight
                            : ColorsTheme().primaryColor,
                      ),
                    ),
                  ],
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
    );
  }
}
