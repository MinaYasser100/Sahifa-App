import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';

class PdfLoadingWidget extends StatelessWidget {
  const PdfLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: ColorsTheme().primaryColor),
          const SizedBox(height: 16),
          Text(
            'loading_pdf'.tr(),
            style: TextStyle(color: ColorsTheme().grayColor),
          ),
        ],
      ),
    );
  }
}
