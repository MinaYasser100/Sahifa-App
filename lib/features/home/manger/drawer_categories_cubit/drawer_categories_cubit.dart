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
    emit(DrawerCategoriesLoading());
    final result = await _drawerCategoriesRepo.fetchDrawerCategories(language);
    result.fold(
      (failure) => emit(DrawerCategoriesError(failure)),
      (categories) => emit(DrawerCategoriesLoaded(categories)),
    );
  }

  // Force refresh - clears cache and fetches new data
  Future<void> refreshDrawerCategories(String language) async {
    emit(DrawerCategoriesLoading());
    final result = await (_drawerCategoriesRepo as DrawerCategoriesRepoImpl)
        .forceRefresh(language);
    result.fold(
      (failure) => emit(DrawerCategoriesError(failure)),
      (categories) => emit(DrawerCategoriesLoaded(categories)),
    );
  }
}
