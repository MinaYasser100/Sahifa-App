import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DateRangeFilterTitle extends StatelessWidget {
  const DateRangeFilterTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'filter_by_date'.tr(),
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
