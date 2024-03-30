import 'dart:async';

import 'package:dio/dio.dart';

import '../dtos/notification_dto.dart';

class NotifiApiClient {
  final Dio dio;
  NotifiApiClient({required this.dio});

  Future<List<NotificationDto>> getNotifications(String token) async {
    late final Response res;
    try {
      res = await dio.get('/notifications/unread',
          options: Options(headers: {"authorization": "Bearer $token"}));
      // print(res.data);

      // return (List.from(res.data).map((e) => NotificationDto.fromJson(e)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
    return (List.from(res.data).map((e) => NotificationDto.fromJson(e)))
        .toList();
  }

  Future<String> markAsRead(String id, String token) async {
    try {
      final res = await dio.delete('/notifications/$id/read',
          options: Options(headers: {"authorization": "Bearer $token"}));
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      }
      throw Exception(e.message);
    }
  }
}
