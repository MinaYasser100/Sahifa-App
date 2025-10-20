import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfGridItemNOImage extends StatelessWidget {
  const PdfGridItemNOImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsTheme().primaryColor.withValues(alpha: 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_rounded,
            size: 40,
            color: ColorsTheme().primaryColor,
          ),
          const SizedBox(height: 8),
          Text(
            'pdf'.tr(),
            style: TextStyle(
              color: ColorsTheme().primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
