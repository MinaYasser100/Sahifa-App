import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/core/utils/date_utils.dart' as date_utils;
import 'package:sahifa/features/pdf/data/repo/pdf_repo.dart';

part 'pdf_state.dart';

class PdfCubit extends Cubit<PdfState> {
  PdfCubit(this._pdfRepo) : super(PdfInitial());
  final PdfRepo _pdfRepo;

  PdfModel? _currentPdf;
  PdfModel? get currentPdf => _currentPdf;

  /// Fetch PDF by date - converts DateTime to UTC string format
  Future<void> fetchPdfByDate(DateTime date) async {
    emit(PdfLoading());

    // Convert DateTime to UTC string format: 2025-10-20T10:00:36.1794008
    final dateUtc = date_utils.DateUtils.convertToUtcString(date);

    final result = await _pdfRepo.getPdf(dateUtc);
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
