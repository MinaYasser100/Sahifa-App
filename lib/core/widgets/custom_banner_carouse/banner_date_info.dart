import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class BannerDateInfo extends StatelessWidget {
  const BannerDateInfo({super.key, required this.dateTime});

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.access_time, size: 16, color: Colors.white70),
        const SizedBox(width: 4),
        Text(
          _formatDate(dateTime),
          style: TextStyle(fontSize: 14, color: ColorsTheme().whiteColor),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    // Format: 12 Oct 2025
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
