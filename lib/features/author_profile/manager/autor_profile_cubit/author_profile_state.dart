part of 'author_profile_cubit.dart';

@immutable
sealed class AuthorProfileState {}

final class AuthorProfileInitial extends AuthorProfileState {}

final class AuthorProfileLoading extends AuthorProfileState {}

final class AuthorProfileLoaded extends AuthorProfileState {
  final List<ArticleModel> articles;
  final bool hasMorePages;

  AuthorProfileLoaded({required this.articles, required this.hasMorePages});
}

final class AuthorProfileError extends AuthorProfileState {
  final String message;

  AuthorProfileError(this.message);
}
