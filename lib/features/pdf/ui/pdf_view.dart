import 'package:flutter/material.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_page_indicator.dart';

class PdfView extends StatefulWidget {
  const PdfView({super.key, this.pdfPath});

  final String? pdfPath;

  @override
  State<PdfView> createState() => _PdfViewState();
}

class _PdfViewState extends State<PdfView> with SingleTickerProviderStateMixin {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _currentPageNumber = 1;
  int _totalPages = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        elevation: 0,
        actions: [
          PdfPageIndicator(
            currentPage: _currentPageNumber,
            totalPages: _totalPages,
          ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer
          SfPdfViewerTheme(
            data: SfPdfViewerThemeData(
              backgroundColor: ColorsTheme().whiteColor,
            ),
            child: SfPdfViewer.asset(
              widget.pdfPath ?? 'assets/pdf/World_Events_Chronicle_2025.pdf',
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

          // زر التقليب اليسار (Previous)
          if (_currentPageNumber > 1)
            Positioned(
              left: 12,
              top: MediaQuery.of(context).size.height / 2 - 30,
              child: _buildNavigationButton(
                icon: Icons.chevron_left_rounded,
                onPressed: () {
                  _animatePageChange(() {
                    _pdfViewerController.previousPage();
                  });
                },
                isLeft: true,
              ),
            ),

          // زر التقليب اليمين (Next)
          if (_currentPageNumber < _totalPages)
            Positioned(
              right: 12,
              top: MediaQuery.of(context).size.height / 2 - 30,
              child: _buildNavigationButton(
                icon: Icons.chevron_right_rounded,
                onPressed: () {
                  _animatePageChange(() {
                    _pdfViewerController.nextPage();
                  });
                },
                isLeft: false,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isLeft,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: ColorsTheme().primaryColor.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Icon(icon, color: ColorsTheme().primaryLight, size: 32),
          ),
        ),
      ),
    );
  }

  void _animatePageChange(VoidCallback pageChangeCallback) {
    _animationController.forward().then((_) {
      pageChangeCallback();
      _animationController.reverse();
    });
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    _animationController.dispose();
    super.dispose();
  }
}
