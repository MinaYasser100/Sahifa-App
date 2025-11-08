import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/altharwa_archive/manager/date_filter_cubit/date_filter_cubit.dart';
import 'package:sahifa/features/altharwa_archive/manager/magazines_cubit/magazines_cubit.dart';

import 'date_range_filter_fields.dart';
import 'date_range_filter_sheet_widgets/date_range_clear_filter_button.dart';
import 'date_range_filter_sheet_widgets/date_range_filter_title.dart';
import 'date_range_filter_sheet_widgets/date_range_search_button.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorsTheme().whiteColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const DateRangeFilterTitle(),
          const SizedBox(height: 24),

          // Date Fields
          DateRangeFilterFields(
            onFromDateTap: () => selectDate(context, fromSelectedDate, true),
            onToDateTap: () => selectDate(context, toSelectedDate, false),
            fromSelectedDate: fromSelectedDate,
            toSelectedDate: toSelectedDate,
          ),
          const SizedBox(height: 24),

          // Search Button
          DateRangeSearchButton(
            fromSelectedDateController: fromSelectedDate,
            toSelectedDateController: toSelectedDate,
            fromDate: _fromDate,
            toDate: _toDate,
            magazinesCubit: widget.magazinesCubit,
            dateFilterCubit: widget.dateFilterCubit,
          ),
          const SizedBox(height: 16),

          // Clear Filter Button
          DateRangeClearFilterButton(
            magazinesCubit: widget.magazinesCubit,
            dateFilterCubit: widget.dateFilterCubit,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
