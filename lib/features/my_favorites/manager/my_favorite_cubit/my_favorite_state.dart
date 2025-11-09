part of 'my_favorite_cubit.dart';

@immutable
sealed class MyFavoriteState {}

final class MyFavoriteInitial extends MyFavoriteState {}

final class MyFavoriteLoading extends MyFavoriteState {}

final class MyFavoriteLoaded extends MyFavoriteState {
  final List<ArticleModel> favorites;

  MyFavoriteLoaded(this.favorites);
}

final class MyFavoriteLoadingMore extends MyFavoriteState {
  final List<ArticleModel> favorites;

  MyFavoriteLoadingMore(this.favorites);
}

final class MyFavoriteError extends MyFavoriteState {
  final String message;

  MyFavoriteError(this.message);
}
