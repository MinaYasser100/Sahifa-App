part of 'articles_search_category_cubit.dart';

@immutable
sealed class ArticlesSearchCategoryState {}

final class ArticlesSearchCategoryInitial extends ArticlesSearchCategoryState {}

final class ArticlesSearchCategoryLoading extends ArticlesSearchCategoryState {}

final class ArticlesSearchCategoryLoadingMore
    extends ArticlesSearchCategoryState {
  ArticlesSearchCategoryLoadingMore(this.currentArticles);

  final List<ArticleModel> currentArticles;
}

final class ArticlesSearchCategoryLoaded extends ArticlesSearchCategoryState {
  ArticlesSearchCategoryLoaded(this.articles, {this.hasMore = false});

  final List<ArticleModel> articles;
  final bool hasMore;
}

final class ArticlesSearchCategoryEmpty extends ArticlesSearchCategoryState {}

final class ArticlesSearchCategoryError extends ArticlesSearchCategoryState {
  ArticlesSearchCategoryError(this.error);

  final Object error;
}
