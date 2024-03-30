import 'package:dio/dio.dart';

const String host = '115.79.196.171';
const String port = '2011';

final dioServer = Dio(
  BaseOptions(
    baseUrl: 'http://$host:2011/api',
    //'http://192.168.1.77:2011/api',
    receiveDataWhenStatusError: true,
    connectTimeout: const Duration(seconds: 10), // 60 seconds
  ),
);

final dioFarm = Dio(BaseOptions(baseUrl: 'http://115.79.196.171:6789/'));

const String serverUrl = '$host:$port';
