import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/pdf/ui/func/build_navigation_button.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerWidget extends StatelessWidget {
  const PdfViewerWidget({
    super.key,
    required this.pdfUrl,
    required this.selectedDate,
    required this.pdfViewerController,
    required this.currentPageNumber,
    required this.totalPages,
    required this.isArabic,
    required this.onDocumentLoaded,
    required this.onPageChanged,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  final String pdfUrl;
  final DateTime selectedDate;
  final PdfViewerController pdfViewerController;
  final int currentPageNumber;
  final int totalPages;
  final bool isArabic;
  final Function(PdfDocumentLoadedDetails) onDocumentLoaded;
  final Function(PdfPageChangedDetails) onPageChanged;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // PDF Viewer with network URL
        SfPdfViewerTheme(
          data: SfPdfViewerThemeData(backgroundColor: ColorsTheme().whiteColor),
          child: SfPdfViewer.network(
            pdfUrl,
            key: ValueKey(selectedDate.toString()),
            controller: pdfViewerController,
            pageLayoutMode: PdfPageLayoutMode.single,
            scrollDirection: PdfScrollDirection.horizontal,
            pageSpacing: 0,
            canShowScrollHead: false,
            interactionMode: PdfInteractionMode.selection,
            onDocumentLoaded: onDocumentLoaded,
            onPageChanged: onPageChanged,
          ),
        ),

        // Navigation buttons
        if (currentPageNumber > 1)
          Positioned(
            left: 12,
            top: MediaQuery.of(context).size.height / 2 - 30,
            child: buildNavigationButton(
              icon: isArabic
                  ? Icons.chevron_right_rounded
                  : Icons.chevron_left_rounded,
              onPressed: onPreviousPage,
              isLeft: true,
            ),
          ),

        if (currentPageNumber < totalPages)
          Positioned(
            right: 12,
            top: MediaQuery.of(context).size.height / 2 - 30,
            child: buildNavigationButton(
              icon: isArabic
                  ? Icons.chevron_left_rounded
                  : Icons.chevron_right_rounded,
              onPressed: onNextPage,
              isLeft: false,
            ),
          ),
      ],
    );
  }
}
