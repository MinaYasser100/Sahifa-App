import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date_from_utc.dart';
import 'package:sahifa/core/theme/app_style.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfGridItemInfo extends StatelessWidget {
  const PdfGridItemInfo({
    super.key,
    required this.issueNumber,
    required this.isDarkMode,
    required this.date,
  });

  final String? issueNumber;
  final bool isDarkMode;
  final String? date;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Issue Number
          if (issueNumber != null && issueNumber!.isNotEmpty)
            Text(
              '${'issue_number'.tr()}: $issueNumber',
              style: AppTextStyles.styleRegular14sp(context).copyWith(
                color: isDarkMode
                    ? ColorsTheme().whiteColor
                    : ColorsTheme().primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

          // Date
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              formatDateFromUTC(date),
              style: TextStyle(
                fontSize: 15,
                color: isDarkMode
                    ? ColorsTheme().whiteColor.withValues(alpha: 0.7)
                    : ColorsTheme().primaryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
