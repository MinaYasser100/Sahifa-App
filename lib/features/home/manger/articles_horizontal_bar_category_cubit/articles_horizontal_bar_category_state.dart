part of 'articles_horizontal_bar_category_cubit.dart';

@immutable
sealed class ArticlesHorizontalBarCategoryState {}

final class ArticlesHorizontalBarCategoryInitial
    extends ArticlesHorizontalBarCategoryState {}

final class ArticlesHorizontalBarCategoryLoading
    extends ArticlesHorizontalBarCategoryState {}

final class ArticlesHorizontalBarCategorySuccess
    extends ArticlesHorizontalBarCategoryState {
  final List<ArticleModel> articles;
  ArticlesHorizontalBarCategorySuccess(this.articles);
}

final class ArticlesHorizontalBarCategoryError
    extends ArticlesHorizontalBarCategoryState {
  final String message;
  ArticlesHorizontalBarCategoryError(this.message);
}
