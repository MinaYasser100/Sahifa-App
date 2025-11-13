import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/magazine_model/magazine_model/pdf_model.dart';
import 'package:sahifa/features/altharwa_archive/data/repo/magazines_repo.dart';

part 'magazines_state.dart';

class MagazinesCubit extends Cubit<MagazinesState> {
  MagazinesCubit(this.magazinesRepo) : super(MagazinesInitial());

  final MagazinesRepo magazinesRepo;

  List<PdfModel> _allMagazines = [];
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isFetchingMore = false;

  /// Fetch initial magazines (page 1)
  Future<void> fetchMagazines() async {
    if (isClosed) return;

    // Only emit loading if no valid cache
    if (!magazinesRepo.hasValidCache(1)) {
      emit(MagazinesLoading());
    }

    final result = await magazinesRepo.getMagazines(pageNumber: 1);

    if (isClosed) return;

    result.fold((error) => emit(MagazinesError(error)), (magazineModel) {
      _allMagazines = magazineModel.items ?? [];
      _currentPage = magazineModel.pageNumber ?? 1;
      _totalPages = magazineModel.totalPages ?? 1;

      emit(
        MagazinesLoaded(
          magazines: _allMagazines,
          currentPage: _currentPage,
          totalPages: _totalPages,
          hasMore: _currentPage < _totalPages,
        ),
      );
    });
  }

  /// Fetch magazines with date range filter
  Future<void> fetchMagazinesWithDateFilter({
    required String fromDate,
    required String toDate,
  }) async {
    if (isClosed) return;

    emit(MagazinesLoading());

    final result = await magazinesRepo.searchMagazinesByRangeDate(
      fromDate: fromDate,
      toDate: toDate,
      pageNumber: 1,
    );

    if (isClosed) return;

    result.fold((error) => emit(MagazinesError(error)), (magazineModel) {
      _allMagazines = magazineModel.items ?? [];
      _currentPage = magazineModel.pageNumber ?? 1;
      _totalPages = magazineModel.totalPages ?? 1;

      emit(
        MagazinesLoaded(
          magazines: _allMagazines,
          currentPage: _currentPage,
          totalPages: _totalPages,
          hasMore: _currentPage < _totalPages,
        ),
      );
    });
  }

  /// Load more magazines (pagination)
  /// Can be called with optional date filters
  Future<void> loadMoreMagazines({String? fromDate, String? toDate}) async {
    if (isClosed || _isFetchingMore || _currentPage >= _totalPages) return;

    _isFetchingMore = true;

    // Emit loading more state with current magazines
    emit(
      MagazinesLoadingMore(magazines: _allMagazines, currentPage: _currentPage),
    );

    final nextPage = _currentPage + 1;

    // Use appropriate method based on filter state
    final bool hasFilter = fromDate != null && toDate != null;
    final result = hasFilter
        ? await magazinesRepo.searchMagazinesByRangeDate(
            fromDate: fromDate,
            toDate: toDate,
            pageNumber: nextPage,
          )
        : await magazinesRepo.getMagazines(pageNumber: nextPage);

    if (isClosed) {
      _isFetchingMore = false;
      return;
    }

    result.fold(
      (error) {
        _isFetchingMore = false;
        // Keep current state, just show error in snackbar or something
        emit(
          MagazinesLoaded(
            magazines: _allMagazines,
            currentPage: _currentPage,
            totalPages: _totalPages,
            hasMore: _currentPage < _totalPages,
          ),
        );
      },
      (magazineModel) {
        _allMagazines.addAll(magazineModel.items ?? []);
        _currentPage = magazineModel.pageNumber ?? _currentPage;
        _totalPages = magazineModel.totalPages ?? _totalPages;
        _isFetchingMore = false;

        emit(
          MagazinesLoaded(
            magazines: _allMagazines,
            currentPage: _currentPage,
            totalPages: _totalPages,
            hasMore: _currentPage < _totalPages,
          ),
        );
      },
    );
  }
}
