import 'dart:developer';

import 'package:vas_iot_app/features/auth/dtos/change_pw_dto.dart';

import '../../result_type.dart';
import '../dtos/login_dto.dart';
import '../dtos/register_dto.dart';
import 'auth_api_client.dart';
import 'auth_local_data_source.dart';

class AuthRepository {
  final AuthApiClient authApiClient;
  final AuthLocalDataSource authLocalDataSource;

  AuthRepository(
      {required this.authApiClient, required this.authLocalDataSource});

  Future<Result<void>> login(String username, String password) async {
    try {
      final loginSuccessDto = await authApiClient
          .login(LoginDto(username: username, password: password));

      await authLocalDataSource.saveToken(loginSuccessDto.token);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
    return Success(null);
  }

  Future<Result<String?>> register(
      String username, String email, String password) async {
    try {
      final res = await authApiClient.register(
          RegisterDto(email: email, password: password, username: username));
      // print(res);
      return Success(res);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String?>> changePassword(
      String userId, String oldPassword, String newPassword) async {
    try {
      final res = await authApiClient.changePassword(ChangePwDto(
          userId: userId, oldPassword: oldPassword, newPassword: newPassword));

      // print(res);
      return Success(res);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String?>> forgotPassword(String email) async {
    try {
      final res = await authApiClient.forgotPassword(email);
      // print(res);
      return Success(res);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String?>> getToken() async {
    try {
      final role = await authLocalDataSource.getToken();
      if (role == null) {
        return Success(null);
      }
      return Success(role);
    } catch (e) {
      return Failure('$e');
    }
  }

  Future<Result<void>> logout() async {
    try {
      final token = await authLocalDataSource.getToken();
      // print(token);
      await authApiClient.logout(token!);
      await authLocalDataSource.clearRole();
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}
