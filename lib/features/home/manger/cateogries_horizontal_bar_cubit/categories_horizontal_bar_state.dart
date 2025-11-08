part of 'categories_horizontal_bar_cubit.dart';

@immutable
sealed class CategoriesHorizontalBarState {}

final class CategoriesHorizontalBarInitial
    extends CategoriesHorizontalBarState {}

final class CategoriesHorizontalBarLoading
    extends CategoriesHorizontalBarState {}

final class CategoriesHorizontalBarLoaded extends CategoriesHorizontalBarState {
  final List<ParentCategory> categories;

  CategoriesHorizontalBarLoaded(this.categories);
}

final class CategoriesHorizontalBarError extends CategoriesHorizontalBarState {
  final String errorMessage;

  CategoriesHorizontalBarError(this.errorMessage);
}
