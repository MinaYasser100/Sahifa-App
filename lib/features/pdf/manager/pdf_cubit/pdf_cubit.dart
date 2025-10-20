import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/features/pdf/data/repo/pdf_repo.dart';

part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit(this._pdfRepo) : super(PdfInitial());
  final PdfRepo _pdfRepo;

  PdfModel? _currentPdf;
  PdfModel? get currentPdf => _currentPdf;

  /// Fetch PDF by date (format: DD/MM/YYYY)
  Future<void> fetchPdfByDate(DateTime date) async {
    emit(PdfLoading());

    // Format date as DD/MM/YYYY (required by API)
    final formattedDate =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

    final result = await _pdfRepo.getPdf(formattedDate);
    result.fold((failure) => emit(PdfError(failure)), (pdfModel) {
      _currentPdf = pdfModel;
      emit(PdfLoaded(pdfModel));
    });
  }

  /// Fetch today's PDF
  Future<void> fetchTodayPdf() async {
    await fetchPdfByDate(DateTime.now());
  }
}
