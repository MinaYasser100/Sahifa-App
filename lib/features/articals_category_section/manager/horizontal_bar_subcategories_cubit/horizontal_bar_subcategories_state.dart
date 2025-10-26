part of 'horizontal_bar_subcategories_cubit.dart';

@immutable
sealed class HorizontalBarSubcategoriesState {}

final class HorizontalBarSubcategoriesInitial
    extends HorizontalBarSubcategoriesState {}

final class HorizontalBarSubcategoriesLoading
    extends HorizontalBarSubcategoriesState {}

final class HorizontalBarSubcategoriesLoaded
    extends HorizontalBarSubcategoriesState {
  HorizontalBarSubcategoriesLoaded(this.subcategories);

  final List<SubcategoryInfoModel> subcategories;
}

final class HorizontalBarSubcategoriesError
    extends HorizontalBarSubcategoriesState {
  HorizontalBarSubcategoriesError(this.error);

  final Object error;
}
