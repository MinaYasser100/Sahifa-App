part of 'articles_drawer_subcategory_cubit.dart';

@immutable
sealed class ArticlesDrawerSubcategoryState {}

final class ArticlesDrawerSubcategoryInitial
    extends ArticlesDrawerSubcategoryState {}

final class ArticlesDrawerSubcategoryLoading
    extends ArticlesDrawerSubcategoryState {}

final class ArticlesDrawerSubcategoryLoaded
    extends ArticlesDrawerSubcategoryState {
  final List<ArticleModel> articles;

  ArticlesDrawerSubcategoryLoaded(this.articles);
}

final class ArticlesDrawerSubcategoryError
    extends ArticlesDrawerSubcategoryState {
  final String message;

  ArticlesDrawerSubcategoryError(this.message);
}
