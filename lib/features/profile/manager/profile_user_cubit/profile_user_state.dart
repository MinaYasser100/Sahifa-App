part of 'profile_user_cubit.dart';

@immutable
sealed class ProfileUserState {}

final class ProfileUserInitial extends ProfileUserState {}

final class ProfileUserLoading extends ProfileUserState {}

final class ProfileUserSuccess extends ProfileUserState {
  final PublicUserProfileModel profile;

  ProfileUserSuccess({required this.profile});
}

final class ProfileUserError extends ProfileUserState {
  final String message;

  ProfileUserError({required this.message});
}
