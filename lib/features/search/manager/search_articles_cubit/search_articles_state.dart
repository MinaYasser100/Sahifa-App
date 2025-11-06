part of 'search_articles_cubit.dart';

@immutable
sealed class SearchArticlesState {}

final class SearchArticlesInitial extends SearchArticlesState {}

final class SearchArticlesLoadingState extends SearchArticlesState {}

final class SearchArticlesLoadedState extends SearchArticlesState {
  final List<ArticleModel> articles;
  SearchArticlesLoadedState(this.articles);
}

final class SearchArticlesErrorState extends SearchArticlesState {
  final String message;
  SearchArticlesErrorState(this.message);
}
