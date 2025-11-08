part of 'details_article_cubit.dart';

@immutable
sealed class DetailsArticleState {}

final class DetailsArticleInitial extends DetailsArticleState {}

final class DetailsArticleLoading extends DetailsArticleState {}

final class DetailsArticleLoaded extends DetailsArticleState {
  DetailsArticleLoaded(this.article);
  final ArticleModel article;
}

final class DetailsArticleError extends DetailsArticleState {
  DetailsArticleError(this.message);
  final String message;
}
