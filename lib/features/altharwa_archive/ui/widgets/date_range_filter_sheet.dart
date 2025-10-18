import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

import 'date_range_filter_fields.dart';

class DateRangeFilterSheet extends StatefulWidget {
  const DateRangeFilterSheet({super.key});

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
      lastDate: DateTime(2100),
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
            child: ElevatedButton(
              onPressed: () {
                // Handle search logic here
                if (fromSelectedDate.text.isNotEmpty &&
                    toSelectedDate.text.isNotEmpty) {
                  // Perform search
                  Navigator.pop(context);
                  // Add your search logic here
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('please_select_both_dates'.tr()),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },

              child: Text(
                'search'.tr(),
                style: AppTextStyles.styleBold16sp(context),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
