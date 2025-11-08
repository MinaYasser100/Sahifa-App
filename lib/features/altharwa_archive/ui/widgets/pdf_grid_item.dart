import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import 'pdf_grid_item_cached_image.dart';
import 'pdf_grid_item_info.dart';
import 'pdf_grid_item_no_image.dart';

class PdfGridItem extends StatelessWidget {
  const PdfGridItem({
    super.key,
    required this.thumbnailUrl,
    required this.issueNumber,
    required this.date,
    required this.onTap,
  });

  final String? thumbnailUrl;
  final String? issueNumber;
  final String? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: FadeInUp(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Thumbnail Image
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(4)),
                child: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
                    ? PdfGridItemCachedImage(thumbnailUrl: thumbnailUrl)
                    : PdfGridItemNOImage(),
              ),
            ),

            // Info Section
            PdfGridItemInfo(
              issueNumber: issueNumber,
              isDarkMode: isDarkMode,
              date: date,
            ),
          ],
        ),
      ),
    );
  }
}
