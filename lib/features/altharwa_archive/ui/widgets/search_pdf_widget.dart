import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_page_indicator.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/custom_pdf_bottom_bar.dart';

class SearchPDFWidget extends StatefulWidget {
  const SearchPDFWidget({super.key, this.pdfPath});

  final String? pdfPath;

  @override
  State<SearchPDFWidget> createState() => _SearchPDFWidgetState();
}

class _SearchPDFWidgetState extends State<SearchPDFWidget> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPageNumber = 1;
  int _totalPages = 0;
  static const double _initialZoomLevel = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('pdf_viewer'.tr()),
        elevation: 0,
        actions: [
          PdfPageIndicator(
            currentPage: _currentPageNumber,
            totalPages: _totalPages,
          ),
        ],
      ),
      body: SfPdfViewerTheme(
        data: SfPdfViewerThemeData(
          backgroundColor: ColorsTheme().whiteColor, // لون خلفية أبيض
        ),
        child: SfPdfViewer.asset(
          widget.pdfPath!,
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
