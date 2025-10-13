import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date.dart';

class CustomArticleItemMetadata extends StatelessWidget {
  const CustomArticleItemMetadata({
    super.key,
    required this.date,
    required this.viewerCount,
  });

  final DateTime date;
  final int viewerCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // التاريخ
        _MetadataItem(icon: Icons.access_time, text: formatDate(date)),
        // عدد المشاهدين
        _MetadataItem(
          icon: Icons.visibility,
          text: _formatViewCount(viewerCount),
        ),
      ],
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}

class _MetadataItem extends StatelessWidget {
  const _MetadataItem({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[500]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
