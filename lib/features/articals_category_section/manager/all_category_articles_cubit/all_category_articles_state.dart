part of 'all_category_articles_cubit.dart';

@immutable
sealed class AllCategoryArticlesState {}

final class AllCategoryArticlesInitial extends AllCategoryArticlesState {}

final class AllCategoryArticlesLoading extends AllCategoryArticlesState {}

final class AllCategoryArticlesLoadingMore extends AllCategoryArticlesState {
  final List<ArticleModel> currentArticles;

  AllCategoryArticlesLoadingMore(this.currentArticles);
}

final class AllCategoryArticlesLoaded extends AllCategoryArticlesState {
  final List<ArticleModel> articles;
  final bool hasMore;

  AllCategoryArticlesLoaded(this.articles, {required this.hasMore});
}

final class AllCategoryArticlesEmpty extends AllCategoryArticlesState {}

final class AllCategoryArticlesError extends AllCategoryArticlesState {
  final String errorMessage;

  AllCategoryArticlesError(this.errorMessage);
}
