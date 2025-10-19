import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sahifa/core/utils/colors.dart';
import 'package:sahifa/features/pdf/ui/func/build_navigation_button.dart';
import 'package:sahifa/features/pdf/ui/func/pdf_download_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_page_indicator.dart';
import 'package:sahifa/features/pdf/ui/widgets/newspaper_info_bar.dart';

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
  DateTime _selectedDate = DateTime.now();
  final String _issueNumber = '2252';
  String _pdfPath = '';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pdfPath = widget.pdfPath ?? 'assets/pdf/World_Events_Chronicle_2025.pdf';
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.download, size: 20),
          onPressed: () {
            _downloadPdf();
          },
        ),
        title: Text('al_thawra'.tr()),
        elevation: 0,
        actions: [
          PdfPageIndicator(
            currentPage: _currentPageNumber,
            totalPages: _totalPages,
          ),
        ],
      ),
      body: Column(
        children: [
          NewspaperInfoBar(
            currentDate: _selectedDate,
            issueNumber: _issueNumber,
            onDateSelected: (selectedDate) {
              setState(() {
                _selectedDate = selectedDate;
                _currentPageNumber = 1;
              });
              // Update PDF path based on selected date if needed
            },
          ),

          Expanded(
            child: Stack(
              children: [
                // PDF Viewer
                SfPdfViewerTheme(
                  data: SfPdfViewerThemeData(
                    backgroundColor: ColorsTheme().whiteColor,
                  ),
                  child: SfPdfViewer.asset(
                    _pdfPath,
                    key: ValueKey(_selectedDate.toString()),
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

                if (_currentPageNumber > 1)
                  Positioned(
                    left: 12,
                    top: MediaQuery.of(context).size.height / 2 - 30,
                    child: buildNavigationButton(
                      icon: isArabic
                          ? Icons.chevron_right_rounded
                          : Icons.chevron_left_rounded,
                      onPressed: () {
                        _animatePageChange(() {
                          _pdfViewerController.previousPage();
                        });
                      },
                      isLeft: true,
                    ),
                  ),

                if (_currentPageNumber < _totalPages)
                  Positioned(
                    right: 12,
                    top: MediaQuery.of(context).size.height / 2 - 30,
                    child: buildNavigationButton(
                      icon: isArabic
                          ? Icons.chevron_left_rounded
                          : Icons.chevron_right_rounded,
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
          ),
        ],
      ),
    );
  }

  void _downloadPdf() {
    // Generate a filename based on the selected date and issue number
    final formattedDate = _selectedDate.toString().split(' ')[0];
    final fileName = 'AlThawra_${formattedDate}_Issue_$_issueNumber.pdf';

    PdfDownloadHelper.downloadPdfFromAssets(
      context: context,
      assetPath: _pdfPath,
      fileName: fileName,
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
