import 'package:flutter/material.dart';
import 'package:sahifa/core/func/format_date_from_utc.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_page_indicator.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/custom_pdf_bottom_bar.dart';

import 'article_pdf_path_empty_widget.dart';

class ArchivePDFWidget extends StatefulWidget {
  const ArchivePDFWidget({super.key, required this.pdfModel});

  final PdfModel pdfModel;

  @override
  State<ArchivePDFWidget> createState() => _ArchivePDFWidgetState();
}

class _ArchivePDFWidgetState extends State<ArchivePDFWidget> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPageNumber = 1;
  int _totalPages = 0;
  static const double _initialZoomLevel = 1.5;

  @override
  Widget build(BuildContext context) {
    final pdfPath = widget.pdfModel.pdfUrl;

    // Check if pdfPath is null or empty
    if (pdfPath == null || pdfPath.isEmpty) {
      return ArticlePdfPathEmptyWidget(widget: widget);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(formatDateFromUTC(widget.pdfModel.createdAt)),
        elevation: 0,
        actions: [
          PdfPageIndicator(
            currentPage: _currentPageNumber,
            totalPages: _totalPages,
          ),
        ],
      ),
      body: SfPdfViewerTheme(
        data: SfPdfViewerThemeData(backgroundColor: ColorsTheme().whiteColor),
        child: SfPdfViewer.network(
          pdfPath,
          controller: _pdfViewerController,
          pageLayoutMode: PdfPageLayoutMode.single,
          scrollDirection: PdfScrollDirection.horizontal,
          pageSpacing: 0,
          canShowScrollHead: false,
          interactionMode: PdfInteractionMode.selection,
          onDocumentLoaded: (PdfDocumentLoadedDetails details) {
            setState(() {
              _totalPages = details.document.pages.count;
            });
          },
          onPageChanged: (PdfPageChangedDetails details) {
            setState(() {
              _currentPageNumber = details.newPageNumber;
            });
          },
        ),
      ),
      bottomNavigationBar: CustomPdfBottomBar(
        controller: _pdfViewerController,
        currentPageNumber: _currentPageNumber,
        totalPages: _totalPages,
        initialZoomLevel: _initialZoomLevel,
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
