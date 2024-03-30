import 'package:dio/dio.dart';

import '../dtos/history_dto.dart';

class HistoryApiClient {
  final Dio dio;

  HistoryApiClient({required this.dio});

  Future<List<HistoryDto>> getHistories(String id) async {
    late final Response res;
    try {
      res = await dio.get('/history/$id');
      // print(res.data);
      // return (List.from(res.data).map((e) => NotificationDto.fromJson(e)));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception("Connection  Timeout Exception");
      }
      throw Exception(e.message);
    }
    return (List.from(res.data).map((e) => HistoryDto.fromJson(e))).toList();
  }
}
