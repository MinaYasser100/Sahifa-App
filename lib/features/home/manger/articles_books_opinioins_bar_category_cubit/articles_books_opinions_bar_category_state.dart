part of 'articles_books_opinions_bar_category_cubit.dart';

@immutable
sealed class ArticlesBooksOpinionsBarCategoryState {}

final class ArticlesBooksOpinionsBarCategoryInitial
    extends ArticlesBooksOpinionsBarCategoryState {}

final class ArticlesBooksOpinionsBarCategoryLoading
    extends ArticlesBooksOpinionsBarCategoryState {}

final class ArticlesBooksOpinionsBarCategoryLoaded
    extends ArticlesBooksOpinionsBarCategoryState {
  final List<ArticleModel> articles;
  final bool hasMorePages;

  ArticlesBooksOpinionsBarCategoryLoaded({
    required this.articles,
    required this.hasMorePages,
  });
}

final class ArticlesBooksOpinionsBarCategoryError
    extends ArticlesBooksOpinionsBarCategoryState {
  final String message;

  ArticlesBooksOpinionsBarCategoryError(this.message);
}
