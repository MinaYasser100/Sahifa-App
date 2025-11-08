import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/core/model/parent_category/subcategory_info_model.dart';
import 'package:sahifa/features/articals_category_section/data/repo/horizontal_bar_subcategories.dart';

part 'horizontal_bar_subcategories_state.dart';

class HorizontalBarSubcategoriesCubit
    extends Cubit<HorizontalBarSubcategoriesState> {
  HorizontalBarSubcategoriesCubit(this._horizontalBarSubcategoriesRepo)
    : super(HorizontalBarSubcategoriesInitial());

  final HorizontalBarSubcategoriesRepo _horizontalBarSubcategoriesRepo;

  Future<void> fetchSubcategories(
    String parentCategorySlug,
    String language,
  ) async {
    emit(HorizontalBarSubcategoriesLoading());
    final result = await _horizontalBarSubcategoriesRepo
        .getSubcategoriesByParentCategory(
          parentCategorySlug: parentCategorySlug,
        );
    result.fold(
      (error) => emit(HorizontalBarSubcategoriesError(error)),
      (subcategories) => emit(HorizontalBarSubcategoriesLoaded(subcategories)),
    );
  }
}
