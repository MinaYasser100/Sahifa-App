part of 'trending_cubit.dart';

@immutable
abstract class TrendingState {}

class TrendingInitial extends TrendingState {}

class TrendingLoading extends TrendingState {}

class TrendingLoaded extends TrendingState {
  final List<ArticleItemModel> articles;

  TrendingLoaded(this.articles);
}

class TrendingError extends TrendingState {
  final String message;

  TrendingError(this.message);
}
