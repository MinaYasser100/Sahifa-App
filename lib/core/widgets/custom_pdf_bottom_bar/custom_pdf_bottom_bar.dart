import 'package:flutter/material.dart';
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
    return Container(
      decoration: BoxDecoration(color: ColorsTheme().primaryColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous page button
            PdfControlButton(
              icon: Icons.skip_previous_rounded,
              label: 'Previous',
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
            PdfControlButton(
              icon: Icons.skip_next_rounded,
              label: 'Next',
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
