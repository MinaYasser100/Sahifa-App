import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/features/altharwa_archive/manager/date_filter_cubit/date_filter_cubit.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';

import 'date_range_filter_fields.dart';

class DateRangeFilterSheet extends StatefulWidget {
  const DateRangeFilterSheet({
    super.key,
    required this.magazinesCubit,
    required this.dateFilterCubit,
  });

  final MagazinesCubit magazinesCubit;
  final DateFilterCubit dateFilterCubit;

  @override
  State<DateRangeFilterSheet> createState() => _DateRangeFilterSheetState();
}

class _DateRangeFilterSheetState extends State<DateRangeFilterSheet> {
  late TextEditingController fromSelectedDate;
  late TextEditingController toSelectedDate;

  @override
  void initState() {
    fromSelectedDate = TextEditingController();
    toSelectedDate = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    fromSelectedDate.dispose();
    toSelectedDate.dispose();
    super.dispose();
  }

  // Store selected dates as DateTime for conversion
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
    bool isFromDate,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // منع اختيار تاريخ مستقبلي
    );
    if (picked != null) {
      setState(() {
        // Store the DateTime for later conversion
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }

        // Display in user-friendly format
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  // تحويل DateTime لـ UTC String بصيغة ISO 8601 بدون Z
  String _convertToUtcString(DateTime date) {
    // Build the string manually to match backend format exactly
    // Format: 2025-10-20T10:00:36.1794008

    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    // Use current time instead of 00:00:00
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    // Combine millisecond (3 digits) + microsecond (4 digits) = 7 digits total
    final millisecond = now.millisecond.toString().padLeft(3, '0');
    final microsecond = now.microsecond.toString().padLeft(4, '0');
    final fractionalSeconds =
        '$millisecond$microsecond'; // This gives us 7 digits

    // Combine to create: 2025-10-20T10:00:36.1794008
    return '$year-$month-${day}T$hour:$minute:$second.$fractionalSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorsTheme().whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'filter_by_date'.tr(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          // From Date Field
          DateRangeFilterFields(
            onFromDateTap: () => selectDate(context, fromSelectedDate, true),
            onToDateTap: () => selectDate(context, toSelectedDate, false),
            fromSelectedDate: fromSelectedDate,
            toSelectedDate: toSelectedDate,
          ),
          const SizedBox(height: 24),

          // Search Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Validate dates
                if (fromSelectedDate.text.isEmpty ||
                    toSelectedDate.text.isEmpty) {
                  showErrorToast(
                    context,
                    "Error".tr(),
                    'please_select_both_dates'.tr(),
                  );
                  return;
                }

                // Validate that _fromDate and _toDate are set
                if (_fromDate == null || _toDate == null) {
                  showErrorToast(
                    context,
                    "Error".tr(),
                    'please_select_both_dates'.tr(),
                  );
                  return;
                }

                // Set date range in DateFilterCubit (with validation)
                // Use display format (DD/MM/YYYY) for validation
                final error = widget.dateFilterCubit.setDateRange(
                  fromDate: fromSelectedDate.text,
                  toDate: toSelectedDate.text,
                );

                if (error != null) {
                  // Show validation error
                  showErrorToast(context, "Error".tr(), error);
                  return;
                }

                // Convert DateTime to UTC String for API
                final fromUtcString = _convertToUtcString(_fromDate!);
                final toUtcString = _convertToUtcString(_toDate!);

                // Validation passed, fetch filtered magazines with UTC strings
                widget.magazinesCubit.fetchMagazinesWithDateFilter(
                  fromDate: fromUtcString,
                  toDate: toUtcString,
                );
                Navigator.pop(context);
              },
              child: Text(
                'search'.tr(),
                style: AppTextStyles.styleBold16sp(context),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Clear Filter Button
          if (widget.dateFilterCubit.isFiltered)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  widget.dateFilterCubit.clearFilter();
                  widget.magazinesCubit.fetchMagazines();
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: ColorsTheme().primaryColor),
                ),
                child: Text(
                  'clear_filter'.tr(),
                  style: AppTextStyles.styleBold16sp(
                    context,
                  ).copyWith(color: ColorsTheme().primaryColor),
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
