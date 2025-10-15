import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

import 'issue_number_section.dart';
import 'pdf_date_section.dart';

class NewspaperInfoBar extends StatelessWidget {
  const NewspaperInfoBar({
    super.key,
    required this.onDateSelected,
    required this.currentDate,
    required this.issueNumber,
  });

  final Function(DateTime) onDateSelected;
  final DateTime currentDate;
  final String issueNumber;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? ColorsTheme().primaryDark
            : ColorsTheme().whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date Section (Clickable)
          PdfDateSection(
            currentDate: currentDate,
            onDateSelected: onDateSelected,
            isDarkMode: isDarkMode,
          ),

          const SizedBox(width: 12),
          // Vertical Divider
          Container(
            height: 40,
            width: 1.5,
            color: isDarkMode
                ? ColorsTheme().primaryLight.withValues(alpha: 0.2)
                : ColorsTheme().dividerColor,
          ),
          const SizedBox(width: 12),
          // Issue Number Section
          IssueNumberSection(isDarkMode: isDarkMode, issueNumber: issueNumber),
        ],
      ),
    );
  }
}
