import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/constant.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_control_button.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_zoom_controls.dart';

class CustomPdfBottomBar extends StatelessWidget {
  const CustomPdfBottomBar({
    super.key,
    required this.controller,
    required this.currentPageNumber,
    required this.totalPages,
    this.initialZoomLevel = 1.5,
  });

  final PdfViewerController controller;
  final int currentPageNumber;
  final int totalPages;
  final double initialZoomLevel;

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.locale.languageCode == ConstantVariable.arabicLangCode;
    return Container(
      decoration: BoxDecoration(color: ColorsTheme().primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous page button
            isArabic
                ? PdfControlButton(
                    icon: Icons.skip_next_rounded,
                    label: 'next'.tr(),
                    onPressed: currentPageNumber < totalPages
                        ? () => controller.nextPage()
                        : null,
                  )
                : PdfControlButton(
                    icon: Icons.skip_previous_rounded,
                    label: 'previous'.tr(),
                    onPressed: currentPageNumber > 1
                        ? () => controller.previousPage()
                        : null,
                  ),

            // Zoom controls
            PdfZoomControls(
              controller: controller,
              initialZoomLevel: initialZoomLevel,
            ),

            // Next page button
            isArabic
                ? PdfControlButton(
                    icon: Icons.skip_previous_rounded,
                    label: 'previous'.tr(),
                    onPressed: currentPageNumber > 1
                        ? () => controller.previousPage()
                        : null,
                  )
                : PdfControlButton(
                    icon: Icons.skip_next_rounded,
                    label: 'next'.tr(),
                    onPressed: currentPageNumber < totalPages
                        ? () => controller.nextPage()
                        : null,
                  ),
          ],
        ),
      ),
    );
  }
}
