part of 'articles_breaking_news_cubit.dart';

@immutable
sealed class ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsInitial extends ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsLoaded extends ArticlesBreakingNewsState {
  final List<ArticleModel> articles;

  ArticlesBreakingNewsLoaded(this.articles);
}

final class ArticlesBreakingNewsLoading extends ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsError extends ArticlesBreakingNewsState {
  final String message;

  ArticlesBreakingNewsError(this.message);
}
