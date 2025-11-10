part of 'edit_user_info_cubit.dart';

@immutable
sealed class EditUserInfoState {}

final class EditUserInfoInitial extends EditUserInfoState {}

final class EditUserInfoLoading extends EditUserInfoState {}

final class EditUserInfoSuccess extends EditUserInfoState {
  final PublicUserProfileModel profile;

  EditUserInfoSuccess({required this.profile});
}

final class EditUserInfoError extends EditUserInfoState {
  final String message;

  EditUserInfoError({required this.message});
}
