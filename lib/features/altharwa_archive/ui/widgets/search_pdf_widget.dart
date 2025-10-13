import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

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

  @override
  Widget build(BuildContext context) {
    // Use provided path or default
    final pdfPath =
        widget.pdfPath ?? 'assets/pdf/World_Events_Chronicle_2025.pdf';

    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        elevation: 0,
        actions: [
          // Page indicator
          if (_totalPages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$_currentPageNumber / $_totalPages',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          // PDF Viewer
          SfPdfViewer.asset(
            pdfPath,
            controller: _pdfViewerController,
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
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous page button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                if (_currentPageNumber > 1) {
                  _pdfViewerController.previousPage();
                }
              },
            ),

            // Zoom out button
            IconButton(
              icon: const Icon(Icons.zoom_out),
              onPressed: () {
                _pdfViewerController.zoomLevel =
                    (_pdfViewerController.zoomLevel - 0.25).clamp(1.0, 3.0);
              },
            ),

            // Reset zoom button
            IconButton(
              icon: const Icon(Icons.zoom_in_map),
              onPressed: () {
                _pdfViewerController.zoomLevel = 1.0;
              },
            ),

            // Zoom in button
            IconButton(
              icon: const Icon(Icons.zoom_in),
              onPressed: () {
                _pdfViewerController.zoomLevel =
                    (_pdfViewerController.zoomLevel + 0.25).clamp(1.0, 3.0);
              },
            ),

            // Next page button
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                if (_currentPageNumber < _totalPages) {
                  _pdfViewerController.nextPage();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}
