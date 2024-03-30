part of 'auth_bloc.dart';

sealed class AuthEvent {}

class AuthStarted extends AuthEvent {}

class AuthLoginStarted extends AuthEvent {
  final String email;
  final String password;

  AuthLoginStarted({required this.email, required this.password});
}

class AuthRegisterStarted extends AuthEvent {
  final String username;
  final String email;
  final String password;

  AuthRegisterStarted(
      {required this.username, required this.email, required this.password});
}

class AuthChangePasswordStarted extends AuthEvent {
  final String userId;
  final String oldPassword;
  final String newPassword;

  AuthChangePasswordStarted(
      {required this.userId,
      required this.oldPassword,
      required this.newPassword});
}

class AuthForgotPasswordStarted extends AuthEvent {
  final String email;

  AuthForgotPasswordStarted({required this.email});
}

class AuthLoginPrefilled extends AuthEvent {
  final String username;
  final String password;
  final String message;

  AuthLoginPrefilled(
      {required this.username, required this.password, required this.message});
}

class AuthAuthenticateStarted extends AuthEvent {}

class AuthLogoutStarted extends AuthEvent {}
