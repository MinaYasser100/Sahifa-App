part of 'banners_cubit.dart';

@immutable
sealed class BannersState {}

final class BannersInitial extends BannersState {}

final class BannersLoading extends BannersState {}

final class BannersLoaded extends BannersState {
  final List<ArticleModel> banners;

  BannersLoaded(this.banners);
}

final class BannersError extends BannersState {
  final String message;

  BannersError(this.message);
}
