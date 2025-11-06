// lib/features/auth/manager/login_cubit/login_cubit.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sahifa/features/auth/data/models/login_request.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_cubit.dart';
import 'package:sahifa/features/auth/manager/auth_cubit/auth_state.dart';
import 'package:sahifa/features/login/manager/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthCubit _authCubit;

  LoginCubit(this._authCubit) : super(const LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(const LoginLoading());

    try {
      // Call auth cubit to handle login
      await _authCubit.login(LoginRequest(email: email, password: password));

      // Check if login was successful
      if (_authCubit.isAuthenticated) {
        emit(const LoginSuccess());
      } else {
        // Get error from auth cubit state
        final authState = _authCubit.state;
        if (authState is AuthError) {
          emit(LoginError(message: authState.message));
        } else {
          emit(LoginError(message: 'failed_login'.tr()));
        }
      }
    } catch (e) {
      emit(LoginError(message: "Invalid_emailand_password".tr()));
    }
  }

  void reset() {
    emit(const LoginInitial());
  }
}
