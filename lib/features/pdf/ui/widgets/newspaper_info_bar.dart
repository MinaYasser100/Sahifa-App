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

  // Constants
  static const double _horizontalPadding = 20.0;
  static const double _verticalPadding = 12.0;
  static const double _dividerHeight = 40.0;
  static const double _dividerWidth = 1.5;
  static const double _dividerOpacity = 0.2;
  static const double _spacing = 12.0;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _horizontalPadding,
        vertical: _verticalPadding,
      ),
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

          const SizedBox(width: _spacing),

          // Vertical Divider
          _buildDivider(isDarkMode),

          const SizedBox(width: _spacing),

          // Issue Number Section
          IssueNumberSection(isDarkMode: isDarkMode, issueNumber: issueNumber),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDarkMode) {
    return Container(
      height: _dividerHeight,
      width: _dividerWidth,
      color: isDarkMode
          ? ColorsTheme().primaryLight.withOpacity(_dividerOpacity)
          : ColorsTheme().dividerColor,
    );
  }
}
