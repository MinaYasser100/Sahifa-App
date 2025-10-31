// lib/features/auth/manager/login_cubit/login_state.dart

abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String message;

  const LoginSuccess({this.message = 'تم تسجيل الدخول بنجاح'});
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});
}
