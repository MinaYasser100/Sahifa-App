import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sahifa/features/edit_info/data/model/user_update_model.dart';
import 'package:sahifa/features/edit_info/data/repo/edit_user_info_repo.dart';
import 'package:sahifa/features/profile/data/model/public_user_profile_model.dart';

part 'edit_user_info_state.dart';

class EditUserInfoCubit extends Cubit<EditUserInfoState> {
  EditUserInfoCubit(this.editUserInfoRepo) : super(EditUserInfoInitial());

  final EditUserInfoRepo editUserInfoRepo;

  /// Update user information
  Future<void> updateUserInfo({
    required String userId,
    required UserUpdateModel updateModel,
  }) async {
    if (isClosed) return;

    log('🔄 Starting user info update...', name: 'EditUserInfoCubit');
    emit(EditUserInfoLoading());

    final result = await editUserInfoRepo.updateUserInfo(
      userId: userId,
      updateModel: updateModel,
    );

    if (isClosed) return;

    result.fold(
      (error) {
        log('❌ Failed to update user info: $error', name: 'EditUserInfoCubit');
        emit(EditUserInfoError(message: error));
      },
      (profile) {
        log('✅ User info updated successfully', name: 'EditUserInfoCubit');
        emit(EditUserInfoSuccess(profile: profile));
      },
    );
  }

  /// Reset state to initial
  void resetState() {
    if (!isClosed) {
      emit(EditUserInfoInitial());
    }
  }
}
