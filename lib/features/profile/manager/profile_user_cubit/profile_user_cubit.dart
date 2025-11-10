import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/profile/data/model/public_user_profile_model.dart';
import 'package:sahifa/features/profile/data/repo/profile_user_repo.dart';

part 'profile_user_state.dart';

class ProfileUserCubit extends Cubit<ProfileUserState> {
  ProfileUserCubit(this.profileUserRepo) : super(ProfileUserInitial());

  final ProfileUserRepo profileUserRepo;

  /// Fetch public user profile by username
  Future<void> fetchUserProfile(String username) async {
    if (isClosed) return;

    log('👤 Fetching profile for: $username', name: 'ProfileUserCubit');
    emit(ProfileUserLoading());

    final result = await profileUserRepo.getPublicUserProfile(
      username: username,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        log('❌ Failed to fetch profile: $error', name: 'ProfileUserCubit');
        emit(ProfileUserError(message: error));
      },
      (profile) {
        log(
          '✅ Profile loaded successfully for ${profile.userName}',
          name: 'ProfileUserCubit',
        );
        emit(ProfileUserSuccess(profile: profile));
      },
    );
  }

  /// Force refresh profile (clears ETag)
  Future<void> forceRefresh(String username) async {
    if (isClosed) return;

    log('🔄 Force refreshing profile for: $username', name: 'ProfileUserCubit');
    emit(ProfileUserLoading());

    final result = await (profileUserRepo as ProfileUserRepoImpl).forceRefresh(
      username,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        log('❌ Failed to refresh profile: $error', name: 'ProfileUserCubit');
        emit(ProfileUserError(message: error));
      },
      (profile) {
        log('✅ Profile refreshed successfully', name: 'ProfileUserCubit');
        emit(ProfileUserSuccess(profile: profile));
      },
    );
  }
}
