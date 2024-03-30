import 'package:dio/dio.dart';

import '../dtos/device_dto.dart';

class DeviceApiClient {
  final Dio dio;

  DeviceApiClient({required this.dio});

  Future<List<DeviceDto>> getDevices(String token) async {
    late final Response res;
    try {
      res = await dio.get('/devices/getall',
          options: Options(headers: {"authorization": "Bearer $token"}));
      // print(res.data);
      // print(res.data);
      // return (List.from(res.data).map((e) => NotificationDto.fromJson(e)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
    return (List.from(res.data).map((e) => DeviceDto.fromJson(e))).toList();
  }

  Future<String> addDevice(String token, String name, String type) async {
    try {
      final res = await dio.post('/devices/add',
          options: Options(headers: {"authorization": "Bearer $token"}),
          data: {"name": name, "type": type});
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> deleteDevice(String token, String id) async {
    try {
      final res = await dio.delete(
        '/devices/delete/$id',
        options: Options(headers: {"authorization": "Bearer $token"}),
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> updateNameDevice(String token, String id, String name) async {
    try {
      final res = await dio.put(
        '/devices/update/$id',
        options: Options(headers: {"authorization": "Bearer $token"}),
        data: {"name": name},
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> updateDataDevice(
      String token, String id, Map<String, dynamic> data) async {
    try {
      final res = await dio.put(
        '/devices/update/$id',
        options: Options(headers: {"authorization": "Bearer $token"}),
        data: data,
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> shareDevice(String token, String id, String email) async {
    try {
      final res = await dio.post(
        '/devices/share',
        options: Options(headers: {"authorization": "Bearer $token"}),
        data: {"deviceId": id, "email": email},
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> revokeShareDevice(
      String token, String id, String email) async {
    try {
      final res = await dio.post(
        '/devices/revoke-share',
        options: Options(headers: {"authorization": "Bearer $token"}),
        data: {"deviceId": id, "email": email},
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<List<DeviceDto>> getDevicesShared(String token) async {
    late final Response res;
    try {
      res = await dio.get('/devices/devices-shared',
          options: Options(headers: {"authorization": "Bearer $token"}));
      // print(res.data);

      // return (List.from(res.data).map((e) => NotificationDto.fromJson(e)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
    return (List.from(res.data).map((e) => DeviceDto.fromJson(e))).toList();
  }

  Future<dynamic> getSensorDatas(String id, DateTime date) async {
    late final Response res;
    try {
      res = await dio.get(
        '/devices/data/$id/?day=${date.day}&month=${date.month}&year=${date.year}',
      );
      // print(res.data);
      return res.data;
      // return (List.from(res.data).map((e) => NotificationDto.fromJson(e)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
  }

  Future<String> addSchedule(String token, String id, List<String> days,
      String time, bool action, int last) async {
    try {
      final res = await dio.post(
        '/devices/$id/schedule',
        options: Options(headers: {"authorization": "Bearer $token"}),
        data: {"day": days, "time": time, "action": action, "last": last},
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }

  Future<String> deleteSchedule(
      String token, String id, String day, String actionId) async {
    try {
      final res = await dio.delete(
        '/devices/$id/schedule/$day/actions/$actionId',
        options: Options(headers: {"authorization": "Bearer $token"}),
      );
      return res.data['message'];
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['error']);
      } else {
        throw Exception(e.message);
      }
    }
  }
}
