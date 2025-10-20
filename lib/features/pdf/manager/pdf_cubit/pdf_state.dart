part of 'pdf_cubit.dart';

@immutable
sealed class PdfState {}

final class PdfInitial extends PdfState {}

final class PdfLoading extends PdfState {}

final class PdfLoaded extends PdfState {
  final PdfModel pdfModel;
  PdfLoaded(this.pdfModel);
}

final class PdfError extends PdfState {
  final String message;
  PdfError(this.message);
}
