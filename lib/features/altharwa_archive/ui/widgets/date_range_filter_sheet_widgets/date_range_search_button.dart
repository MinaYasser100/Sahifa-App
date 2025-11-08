import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/date_utils.dart' as custom_date_utils;
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/features/altharwa_archive/manager/date_filter_cubit/date_filter_cubit.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';

class DateRangeSearchButton extends StatelessWidget {
  const DateRangeSearchButton({
    super.key,
    required this.fromSelectedDateController,
    required this.toSelectedDateController,
    required this.fromDate,
    required this.toDate,
    required this.magazinesCubit,
    required this.dateFilterCubit,
  });

  final TextEditingController fromSelectedDateController;
  final TextEditingController toSelectedDateController;
  final DateTime? fromDate;
  final DateTime? toDate;
  final MagazinesCubit magazinesCubit;
  final DateFilterCubit dateFilterCubit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _onSearchPressed(context),
        child: Text('search'.tr(), style: AppTextStyles.styleBold16sp(context)),
      ),
    );
  }

  void _onSearchPressed(BuildContext context) {
    // Validate dates
    if (fromSelectedDateController.text.isEmpty ||
        toSelectedDateController.text.isEmpty) {
      showErrorToast(context, "Error".tr(), 'please_select_both_dates'.tr());
      return;
    }

    // Validate that fromDate and toDate are set
    if (fromDate == null || toDate == null) {
      showErrorToast(context, "Error".tr(), 'please_select_both_dates'.tr());
      return;
    }

    // Set date range in DateFilterCubit (with validation)
    final error = dateFilterCubit.setDateRange(
      fromDate: fromSelectedDateController.text,
      toDate: toSelectedDateController.text,
    );

    if (error != null) {
      showErrorToast(context, "Error".tr(), error);
      return;
    }

    // Convert DateTime to UTC String for API
    final fromUtcString = custom_date_utils.DateUtils.convertToUtcString(
      fromDate!,
    );
    final toUtcString = custom_date_utils.DateUtils.convertToUtcString(toDate!);

    // Fetch filtered magazines with UTC strings
    magazinesCubit.fetchMagazinesWithDateFilter(
      fromDate: fromUtcString,
      toDate: toUtcString,
    );
    Navigator.pop(context);
  }
}
