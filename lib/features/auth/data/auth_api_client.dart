import 'package:dio/dio.dart';
import 'package:vas_iot_app/features/auth/dtos/change_pw_dto.dart';

import '../dtos/login_dto.dart';
import '../dtos/login_success_dto.dart';
import '../dtos/register_dto.dart';

class AuthApiClient {
  final Dio dio;

  AuthApiClient(this.dio);
  Future<LoginSuccessDto> login(LoginDto loginDto) async {
    try {
      final res = await dio.post('/auth/login', data: loginDto.toJson());
      if (res.statusCode == 201) {
        throw Exception(res.data['message']);
      }
      return LoginSuccessDto.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> register(RegisterDto registerDto) async {
    // final res = await dio.post('/auth/register', data: registerDto.toJson());
    // print(res.statusCode);
    try {
      final res = await dio.post('/auth/register', data: registerDto.toJson());
      // print(res.statusCode);
      // if (res.statusCode == 201) {
      //   throw Exception(res.data['message']);
      // } else if (res.statusCode == 400 || res.statusCode == 500) {
      //   throw Exception(res.data['error']);
      // }
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> changePassword(ChangePwDto changePwDto) async {
    // final res = await dio.post('/auth/register', data: registerDto.toJson());
    // print(res.statusCode);
    try {
      final res =
          await dio.post('/auth/change-password', data: changePwDto.toJson());

      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> forgotPassword(String email) async {
    // final res = await dio.post('/auth/register', data: registerDto.toJson());
    // print(res.statusCode);
    try {
      final res =
          await dio.post('/auth/forgot-password', data: {"email": email});

      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<void> logout(String token) async {
    try {
      await dio.post(
        '/auth/logout',
        options: Options(
          headers: {
            "authorization": "Bearer $token",
          },
        ),
      );

      // return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
