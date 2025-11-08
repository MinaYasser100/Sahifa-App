part of 'subcategory_articles_cubit.dart';

@immutable
sealed class SubcategoryArticlesState {}

final class SubcategoryArticlesInitial extends SubcategoryArticlesState {}

final class SubcategoryArticlesLoading extends SubcategoryArticlesState {}

final class SubcategoryArticlesLoadingMore extends SubcategoryArticlesState {
  final List<ArticleModel> currentArticles;

  SubcategoryArticlesLoadingMore(this.currentArticles);
}

final class SubcategoryArticlesLoaded extends SubcategoryArticlesState {
  final List<ArticleModel> articles;
  final bool hasMore;

  SubcategoryArticlesLoaded(this.articles, {required this.hasMore});
}

final class SubcategoryArticlesEmpty extends SubcategoryArticlesState {}

final class SubcategoryArticlesError extends SubcategoryArticlesState {
  final String errorMessage;

  SubcategoryArticlesError(this.errorMessage);
}
