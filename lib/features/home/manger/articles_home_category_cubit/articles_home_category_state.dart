part of 'articles_home_category_cubit.dart';

@immutable
sealed class ArticlesHomeCategoryState {}

final class ArticlesHomeCategoryInitial extends ArticlesHomeCategoryState {}

final class ArticlesHomeCategoryLoading extends ArticlesHomeCategoryState {}

final class ArticlesHomeCategorySuccess extends ArticlesHomeCategoryState {
  final List<ArticleModel> articles;

  ArticlesHomeCategorySuccess(this.articles);
}

final class ArticlesHomeCategoryError extends ArticlesHomeCategoryState {
  final String message;

  ArticlesHomeCategoryError(this.message);
}
