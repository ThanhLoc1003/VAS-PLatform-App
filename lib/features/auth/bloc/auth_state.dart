part of 'auth_bloc.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginInitial extends AuthState {
  final String username;
  final String password;
  final String message;
  AuthLoginInitial(
      {required this.username, required this.password, required this.message});
}

class AuthLoginInProgress extends AuthState {}

class AuthLoginSuccess extends AuthState {}

class AuthLoginFailure extends AuthState {
  final String message;

  AuthLoginFailure({required this.message});
}

class AuthRegisterInProgress extends AuthState {}

class AuthRegisterSuccess extends AuthState {
  final String message;

  AuthRegisterSuccess({required this.message});
}

class AuthRegisterFailure extends AuthState {
  final String message;

  AuthRegisterFailure({required this.message});
}

class AuthChangeSuccess extends AuthState {
  final String message;

  AuthChangeSuccess({required this.message});
}

class AuthChangeFailure extends AuthState {
  final String message;

  AuthChangeFailure({required this.message});
}

class AuthForgotSuccess extends AuthState {
  final String message;

  AuthForgotSuccess({required this.message});
}

class AuthForgotFailure extends AuthState {
  final String message;

  AuthForgotFailure({required this.message});
}

class AuthAuthenticateSuccess extends AuthState {
  final String role;

  AuthAuthenticateSuccess(this.role);
}

class AuthAuthenticateFailure extends AuthState {
  final String message;
  AuthAuthenticateFailure(this.message);
}

class AuthLogoutSuccess extends AuthState {}

class AuthLogoutFailure extends AuthState {
  final String message;
  AuthLogoutFailure(this.message);
}

class AuthAuthenticateUnauthenticated extends AuthState {}
