part of 'articles_parent_category_cubit.dart';

@immutable
sealed class ArticlesParentCategoryState {}

final class ArticlesParentCategoryInitial extends ArticlesParentCategoryState {}

final class ArticlesParentCategoryLoading extends ArticlesParentCategoryState {}

final class ArticlesParentCategorySuccess extends ArticlesParentCategoryState {
  final List<ArticleModel> articles;
  ArticlesParentCategorySuccess(this.articles);
}

final class ArticlesParentCategoryError extends ArticlesParentCategoryState {
  final String message;
  ArticlesParentCategoryError(this.message);
}
