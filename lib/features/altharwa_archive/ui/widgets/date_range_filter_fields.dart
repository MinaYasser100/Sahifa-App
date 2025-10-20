import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/model/text_field_model/text_field_model.dart';
import 'package:sahifa/core/widgets/custom_text_form_field.dart';

class DateRangeFilterFields extends StatelessWidget {
  const DateRangeFilterFields({
    super.key,
    this.onFromDateTap,
    this.onToDateTap,
    required this.fromSelectedDate,
    required this.toSelectedDate,
  });
  final void Function()? onFromDateTap;
  final void Function()? onToDateTap;
  final TextEditingController fromSelectedDate;
  final TextEditingController toSelectedDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onFromDateTap,
          child: AbsorbPointer(
            child: CustomTextFormField(
              textFieldModel: TextFieldModel(
                controller: fromSelectedDate,
                hintText: 'from_date'.tr(),
                icon: Icons.calendar_today_rounded,
                keyboardType: TextInputType.none,
                ischangeColor: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_select_a_date'.tr();
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // To Date Field
        GestureDetector(
          onTap: onToDateTap,
          child: AbsorbPointer(
            child: CustomTextFormField(
              textFieldModel: TextFieldModel(
                controller: toSelectedDate,
                hintText: 'to_date'.tr(),
                icon: Icons.calendar_today_rounded,
                ischangeColor: true,
                keyboardType: TextInputType.none,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'please_select_a_date'.tr();
                  }
                  return null;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
