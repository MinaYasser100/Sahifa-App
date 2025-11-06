import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/parent_category.dart';
import 'package:sahifa/features/search/data/repo/search_categories_repo.dart';

part 'search_categories_state.dart';

class SearchCategoriesCubit extends Cubit<SearchCategoriesState> {
  SearchCategoriesCubit(this._searchCategoriesRepo)
    : super(SearchCategoriesInitial());
  final SearchCategoriesRepo _searchCategoriesRepo;

  Future<void> fetchSearchCategories(String language) async {
    emit(SearchCategoriesLoading());
    final result = await _searchCategoriesRepo.fetchSearchCategories(language);
    result.fold((error) => emit(SearchCategoriesError(error)), (categories) {
      // فلترة الـ categories اللي isActive && showOnMenu
      final filteredCategories = categories
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

      emit(SearchCategoriesLoaded(filteredCategories));
    });
  }

  // Force refresh - clears cache and fetches new data
  Future<void> refreshSearchCategories(String language) async {
    emit(SearchCategoriesLoading());
    final result = await (_searchCategoriesRepo as SearchCategoriesRepoImpl)
        .forceRefresh(language);
    result.fold((error) => emit(SearchCategoriesError(error)), (categories) {
      // فلترة الـ categories اللي isActive && showOnMenu
      final filteredCategories = categories
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));

      emit(SearchCategoriesLoaded(filteredCategories));
    });
  }
}
