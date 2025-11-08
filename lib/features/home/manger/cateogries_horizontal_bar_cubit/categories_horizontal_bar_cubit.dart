import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/features/home/data/repo/categories_horizontal_bar_repo.dart';

part 'categories_horizontal_bar_state.dart';

class CategoriesHorizontalBarCubit extends Cubit<CategoriesHorizontalBarState> {
  CategoriesHorizontalBarCubit(this._horizontalBarRepo)
    : super(CategoriesHorizontalBarInitial());

  final CategoriesHorizontalBarRepo _horizontalBarRepo;

  Future<void> fetchCategoriesHorizontalBar(String language) async {
    if (isClosed) return;

    if (!isClosed) emit(CategoriesHorizontalBarLoading());
    final result = await _horizontalBarRepo.fetchCategoriesHorizontalBar(
      language,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(CategoriesHorizontalBarError(error));
      },
      (categories) {
        // فلترة الـ categories اللي isActive && showOnMenu
        final filteredCategories = categories
          ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

        if (!isClosed) emit(CategoriesHorizontalBarLoaded(filteredCategories));
      },
    );
  }

  // Force refresh - clears cache and fetches new data
  Future<void> refreshCategoriesHorizontalBar(String language) async {
    if (isClosed) return;

    if (!isClosed) emit(CategoriesHorizontalBarLoading());
    final result = await (_horizontalBarRepo as CategoriesHorizontalBarRepoImpl)
        .forceRefresh(language);

    if (isClosed) return;

    result.fold(
      (error) {
        if (!isClosed) emit(CategoriesHorizontalBarError(error));
      },
      (categories) {
        // فلترة الـ categories اللي isActive && showOnMenu
        final filteredCategories = categories
          ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

        if (!isClosed) emit(CategoriesHorizontalBarLoaded(filteredCategories));
      },
    );
  }
}
