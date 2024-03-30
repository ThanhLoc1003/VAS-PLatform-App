import 'dart:developer';

import 'package:vas_iot_app/features/platform/data/notifi_api_client.dart';

import '../../../screens/device-shared/shared_screen.dart';
import '../../../screens/main/main_screen.dart';
import '../../result_type.dart';
import 'device_api_client.dart';

class MainRepository {
  final DeviceApiClient deviceApiClient;
  final NotifiApiClient notifiApiClient;
  MainRepository(
      {required this.deviceApiClient, required this.notifiApiClient});

  Future<Result<void>> getDevices(String token) async {
    try {
      devices = await deviceApiClient.getDevices(token);

      return Success(null);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
  }

  Future<Result<void>> getDevicesShared(String token) async {
    try {
      sharedDevices.clear();
      final devicesShared = await deviceApiClient.getDevicesShared(token);
      // await DeviceApiClient(dio: dioServer).getDevicesShared(token);
      for (int i = 0; i < devicesShared.length; i++) {
        for (int j = 0; j < devicesShared[i].sharedWith.length; j++) {
          sharedDevices.add(ShareDevice(
              id: devicesShared[i].id,
              email: devicesShared[i].sharedWith[j],
              name: devicesShared[i].name));
        }
      }

      return Success(null);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
  }

  Future<Result<String>> addDevice(
      String token, String name, String type) async {
    try {
      final message = await deviceApiClient.addDevice(token, name, type);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String>> updateNameDevice(
      String token, String id, String name) async {
    try {
      final message = await deviceApiClient.updateNameDevice(token, id, name);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String>> updateDataDevice(
      String token, String id, Map<String, dynamic> data) async {
    try {
      final message = await deviceApiClient.updateDataDevice(token, id, data);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String>> deleteDevice(String token, String id) async {
    try {
      final message = await deviceApiClient.deleteDevice(token, id);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String>> shareDevice(
      String token, String id, String email) async {
    try {
      final message = await deviceApiClient.shareDevice(token, id, email);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String>> revokeShareDevice(
      String token, String id, String email) async {
    try {
      final message = await deviceApiClient.revokeShareDevice(token, id, email);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<void>> getNotifications(String token) async {
    try {
      notifications = await notifiApiClient.getNotifications(token);
      return Success(null);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
  }

  Future<Result<String>> markAsRead(String id, String token) async {
    try {
      final message = await notifiApiClient.markAsRead(id, token);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure(e.toString());
    }
  }

  Future<Result<String>> addSchedule(String token, String id, List<String> days,
      String time, bool action, int last) async {
    try {
      final message = await deviceApiClient.addSchedule(
          token, id, days, time, action, last);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }

  Future<Result<String>> deleteSchedule(
      String token, String id, String day, String actionId) async {
    try {
      final message =
          await deviceApiClient.deleteSchedule(token, id, day, actionId);
      // print(res);
      return Success(message);
    } catch (e) {
      log('$e');
      return Failure('$e');
    }
  }
}
