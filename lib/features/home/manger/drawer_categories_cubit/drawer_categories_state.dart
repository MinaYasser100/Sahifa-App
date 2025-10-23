part of 'drawer_categories_cubit.dart';

@immutable
sealed class DrawerCategoriesState {}

final class DrawerCategoriesInitial extends DrawerCategoriesState {}

final class DrawerCategoriesLoading extends DrawerCategoriesState {}

final class DrawerCategoriesLoaded extends DrawerCategoriesState {
  final List<ParentCategory> parentCategories;
  DrawerCategoriesLoaded(this.parentCategories);
}

final class DrawerCategoriesError extends DrawerCategoriesState {
  final String message;
  DrawerCategoriesError(this.message);
}
