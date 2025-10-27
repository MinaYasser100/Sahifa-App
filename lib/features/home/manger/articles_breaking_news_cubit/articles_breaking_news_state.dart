part of 'articles_breaking_news_cubit.dart';

@immutable
sealed class ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsInitial extends ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsLoaded extends ArticlesBreakingNewsState {
  final List<ArticleModel> articles;
  final bool hasMore;

  ArticlesBreakingNewsLoaded(this.articles, this.hasMore);
}

final class ArticlesBreakingNewsLoadingMore extends ArticlesBreakingNewsState {
  final List<ArticleModel> currentArticles;

  ArticlesBreakingNewsLoadingMore(this.currentArticles);
}

final class ArticlesBreakingNewsLoading extends ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsEmpty extends ArticlesBreakingNewsState {}

final class ArticlesBreakingNewsError extends ArticlesBreakingNewsState {
  final String message;

  ArticlesBreakingNewsError(this.message);
}
