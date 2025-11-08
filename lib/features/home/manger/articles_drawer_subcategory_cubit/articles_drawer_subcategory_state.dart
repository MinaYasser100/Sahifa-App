part of 'articles_drawer_subcategory_cubit.dart';

@immutable
sealed class ArticlesDrawerSubcategoryState {}

final class ArticlesDrawerSubcategoryInitial
    extends ArticlesDrawerSubcategoryState {}

final class ArticlesDrawerSubcategoryLoading
    extends ArticlesDrawerSubcategoryState {}

final class ArticlesDrawerSubcategoryLoadingMore
    extends ArticlesDrawerSubcategoryState {
  final List<ArticleModel> articles;
  final int currentPage;

  ArticlesDrawerSubcategoryLoadingMore({
    required this.articles,
    required this.currentPage,
  });
}

final class ArticlesDrawerSubcategoryLoaded
    extends ArticlesDrawerSubcategoryState {
  final List<ArticleModel> articles;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  ArticlesDrawerSubcategoryLoaded({
    required this.articles,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });
}

final class ArticlesDrawerSubcategoryError
    extends ArticlesDrawerSubcategoryState {
  final String message;

  ArticlesDrawerSubcategoryError(this.message);
}
