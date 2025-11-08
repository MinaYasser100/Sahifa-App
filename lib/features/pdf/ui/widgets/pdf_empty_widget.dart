import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfEmptyWidget extends StatelessWidget {
  const PdfEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf_outlined,
            size: 64,
            color: ColorsTheme().grayColor,
          ),
          const SizedBox(height: 16),
          Text(
            'no_pdf_found'.tr(),
            style: TextStyle(color: ColorsTheme().grayColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
