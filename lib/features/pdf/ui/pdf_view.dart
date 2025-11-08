import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:sahifa/core/utils/show_top_toast.dart';
import 'package:sahifa/features/pdf/data/repo/pdf_repo.dart';
import 'package:sahifa/features/pdf/manager/pdf_cubit/pdf_cubit.dart';
import 'package:sahifa/features/pdf/ui/func/pdf_network_download_helper.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:sahifa/core/widgets/custom_pdf_bottom_bar/pdf_page_indicator.dart';
import 'package:sahifa/features/pdf/ui/widgets/newspaper_info_bar.dart';
import 'package:sahifa/features/pdf/ui/widgets/pdf_empty_widget.dart';
import 'package:sahifa/features/pdf/ui/widgets/pdf_error_widget.dart';
import 'package:sahifa/features/pdf/ui/widgets/pdf_loading_widget.dart';
import 'package:sahifa/features/pdf/ui/widgets/pdf_viewer_widget.dart';

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
    final isArabic = context.locale.languageCode == 'ar';

    return BlocProvider(
      create: (context) =>
          PdfCubit(GetIt.instance<PdfRepo>())..fetchPdfByDate(_selectedDate),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(FontAwesomeIcons.download, size: 20),
                onPressed: () {
                  _downloadPdf(context);
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
            body: BlocBuilder<PdfCubit, PdfState>(
              builder: (context, state) {
                // Loading State
                if (state is PdfLoading) {
                  return const PdfLoadingWidget();
                }

                // Error State
                if (state is PdfError) {
                  return PdfErrorWidget(
                    errorMessage: state.message,
                    onRetry: () {
                      context.read<PdfCubit>().fetchPdfByDate(_selectedDate);
                    },
                  );
                }

                // Loaded State
                if (state is PdfLoaded) {
                  final pdfModel = state.pdfModel;

                  // Check if PDF URL is available
                  if (pdfModel.pdfUrl == null || pdfModel.pdfUrl!.isEmpty) {
                    return const PdfEmptyWidget();
                  }

                  return Column(
                    children: [
                      NewspaperInfoBar(
                        currentDate: _selectedDate,
                        issueNumber: pdfModel.issueNumber ?? '',
                        onDateSelected: (selectedDate) {
                          setState(() {
                            _selectedDate = selectedDate;
                            _currentPageNumber = 1;
                          });
                          context.read<PdfCubit>().fetchPdfByDate(selectedDate);
                        },
                      ),
                      Expanded(
                        child: PdfViewerWidget(
                          pdfUrl: pdfModel.pdfUrl!,
                          selectedDate: _selectedDate,
                          pdfViewerController: _pdfViewerController,
                          currentPageNumber: _currentPageNumber,
                          totalPages: _totalPages,
                          isArabic: isArabic,
                          onDocumentLoaded: (details) {
                            setState(() {
                              _totalPages = details.document.pages.count;
                            });
                          },
                          onPageChanged: (details) {
                            setState(() {
                              _currentPageNumber = details.newPageNumber;
                            });
                          },
                          onPreviousPage: () {
                            _animatePageChange(() {
                              _pdfViewerController.previousPage();
                            });
                          },
                          onNextPage: () {
                            _animatePageChange(() {
                              _pdfViewerController.nextPage();
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          );
        },
      ),
    );
  }

  void _downloadPdf(BuildContext context) {
    final state = context.read<PdfCubit>().state;
    if (state is PdfLoaded && state.pdfModel.pdfUrl != null) {
      // Generate filename with date format: YYYY-MM-DD
      final year = _selectedDate.year.toString();
      final month = _selectedDate.month.toString().padLeft(2, '0');
      final day = _selectedDate.day.toString().padLeft(2, '0');
      final dateStr = '$year-$month-$day';
      final issueNumber = state.pdfModel.issueNumber ?? 'unknown';
      final fileName = 'AlThawra_${dateStr}_Issue_$issueNumber.pdf';

      // Download PDF from network
      PdfNetworkDownloadHelper.downloadPdfFromNetwork(
        context: context,
        pdfUrl: state.pdfModel.pdfUrl!,
        fileName: fileName,
      );
    } else {
      showErrorToast(context, "Error", "No PDF to download");
    }
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
