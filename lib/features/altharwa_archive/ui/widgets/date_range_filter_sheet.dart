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

  Future<void> selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(), // منع اختيار تاريخ مستقبلي
    );
    if (picked != null) {
      setState(() {
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
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
            onFromDateTap: () => selectDate(context, fromSelectedDate),
            onToDateTap: () => selectDate(context, toSelectedDate),
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

                // Set date range in DateFilterCubit (with validation)
                final error = widget.dateFilterCubit.setDateRange(
                  fromDate: fromSelectedDate.text,
                  toDate: toSelectedDate.text,
                );

                if (error != null) {
                  // Show validation error
                  showErrorToast(context, "Error".tr(), error);
                  return;
                }

                // Validation passed, fetch filtered magazines
                widget.magazinesCubit.fetchMagazinesWithDateFilter(
                  fromDate: fromSelectedDate.text,
                  toDate: toSelectedDate.text,
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
