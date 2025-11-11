part of 'galeries_posts_cubit.dart';

@immutable
sealed class GaleriesPostsState {}

final class GaleriesPostsInitial extends GaleriesPostsState {}

final class GaleriesPostsLoaded extends GaleriesPostsState {
  final List<ArticleModel> articles;
  final bool hasMore;

  GaleriesPostsLoaded(this.articles, this.hasMore);
}

final class GaleriesPostsLoadingMore extends GaleriesPostsState {
  final List<ArticleModel> currentArticles;

  GaleriesPostsLoadingMore(this.currentArticles);
}

final class GaleriesPostsLoading extends GaleriesPostsState {}

final class GaleriesPostsEmpty extends GaleriesPostsState {}

final class GaleriesPostsError extends GaleriesPostsState {
  final String message;

  GaleriesPostsError(this.message);
}
