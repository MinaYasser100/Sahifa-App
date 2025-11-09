part of 'articles_horizontal_books_opinions_cubit.dart';

@immutable
sealed class ArticlesHorizontalBooksOpinionsState {}

final class ArticlesHorizontalBooksOpinionsInitial
    extends ArticlesHorizontalBooksOpinionsState {}

final class ArticlesHorizontalBooksOpinionsLoading
    extends ArticlesHorizontalBooksOpinionsState {}

final class ArticlesHorizontalBooksOpinionsLoaded
    extends ArticlesHorizontalBooksOpinionsState {
  final List<ArticleModel> articles;

  ArticlesHorizontalBooksOpinionsLoaded({required this.articles});
}

final class ArticlesHorizontalBooksOpinionsError
    extends ArticlesHorizontalBooksOpinionsState {
  final String message;

  ArticlesHorizontalBooksOpinionsError(this.message);
}
