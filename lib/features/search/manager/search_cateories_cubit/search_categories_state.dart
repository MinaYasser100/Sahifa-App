part of 'search_categories_cubit.dart';

@immutable
sealed class SearchCategoriesState {}

final class SearchCategoriesInitial extends SearchCategoriesState {}

final class SearchCategoriesLoading extends SearchCategoriesState {}

final class SearchCategoriesLoaded extends SearchCategoriesState {
  SearchCategoriesLoaded(this.categories);
  final List<ParentCategory> categories;
}

final class SearchCategoriesError extends SearchCategoriesState {
  SearchCategoriesError(this.errorMessage);
  final String errorMessage;
}
