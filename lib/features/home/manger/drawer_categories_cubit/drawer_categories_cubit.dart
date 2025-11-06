import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/features/home/data/repo/drawer_categories_repo.dart';

part 'drawer_categories_state.dart';

class DrawerCategoriesCubit extends Cubit<DrawerCategoriesState> {
  DrawerCategoriesCubit(this._drawerCategoriesRepo)
    : super(DrawerCategoriesInitial());
  final DrawerCategoriesRepo _drawerCategoriesRepo;

  Future<void> fetchDrawerCategories(String language) async {
    if (isClosed) return;

    if (!isClosed) emit(DrawerCategoriesLoading());
    final result = await _drawerCategoriesRepo.fetchDrawerCategories(language);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(DrawerCategoriesError(failure));
      },
      (categories) {
        // فلترة الـ categories اللي isActive && showOnMenu
        final filteredCategories = categories
          ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

        if (!isClosed) emit(DrawerCategoriesLoaded(filteredCategories));
      },
    );
  }

  // Force refresh - clears cache and fetches new data
  Future<void> refreshDrawerCategories(String language) async {
    if (isClosed) return;

    if (!isClosed) emit(DrawerCategoriesLoading());
    final result = await (_drawerCategoriesRepo as DrawerCategoriesRepoImpl)
        .forceRefresh(language);

    if (isClosed) return;

    result.fold(
      (failure) {
        if (!isClosed) emit(DrawerCategoriesError(failure));
      },
      (categories) {
        // فلترة الـ categories اللي isActive && showOnMenu
        final filteredCategories = categories
          ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

        if (!isClosed) emit(DrawerCategoriesLoaded(filteredCategories));
      },
    );
  }
}
