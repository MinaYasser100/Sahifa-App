part of 'magazines_cubit.dart';

@immutable
abstract class MagazinesState {}

class MagazinesInitial extends MagazinesState {}

class MagazinesLoading extends MagazinesState {}

class MagazinesLoaded extends MagazinesState {
  final List<PdfModel> magazines;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  MagazinesLoaded({
    required this.magazines,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

class MagazinesLoadingMore extends MagazinesState {
  final List<PdfModel> magazines;
  final int currentPage;

  MagazinesLoadingMore({required this.magazines, required this.currentPage});
}

class MagazinesError extends MagazinesState {
  final String message;

  MagazinesError(this.message);
}
