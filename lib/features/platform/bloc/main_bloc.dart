import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vas_iot_app/features/platform/data/main_repository.dart';

import '../../../screens/main/main_screen.dart';
import '../../../service/wsk_service.dart';
import '../../result_type.dart';
part 'main_event.dart';
part 'main_state.dart';

List<String> deviceIds = [];
late WebSocketManager _webSocketManager;

class MainBloc extends Bloc<MainEvent, MainState> {
  final MainRepository deviceRepository;
  // RealtimeDataService service;

  MainBloc({required this.deviceRepository}) : super(MainInitial()) {
    on<MainEventStarted>(onStarted);
    on<MainEventGetDevicesShared>(onGetDevicesShared);
    on<MainEventAddDevice>(onAddDevice);
    on<MainEventUpdateNameDevice>(onUpdateNameDevice);
    on<MainEventUpdateDevice>(onUpdateDevice);
    on<MainEventDeleteDevice>(onDeleteDevice);
    on<MainEventShareDevice>(onShareDevice);
    on<MainEventRevokeShareDevice>(onRevokeShareDevice);
    on<MainEventMarkAsRead>(onMarkAsRead);
    on<UpdateEvent>(onUpdateEvent);
    on<MainEventAddScene>(onAddScene);
    on<MainEventAddSchedule>(onAddSchedule);
    on<MainEventDeleteSchedule>(onDeleteSchedule);
    _webSocketManager = WebSocketManager();
    // publicService = service;
  }
  void onStarted(MainEventStarted event, Emitter<MainState> emit) async {
    // publicService.start(
    //     _streamController); // This is the service that we created previously

    var result = await deviceRepository.getDevices(event.token);

    result = await deviceRepository.getNotifications(event.token);

    _webSocketManager.stream.listen((data) {
      if (deviceIds.isEmpty) return;
      String websocketData = data.toString().replaceAll("\"", "");

      (deviceIds.contains(websocketData))
          ? add(UpdateEvent(token: event.token, flag: 1))
          : websocketData == email
              ? add(UpdateEvent(token: event.token, flag: 2))
              : websocketData == "$email-share"
                  ? add(UpdateEvent(token: event.token, flag: 3))
                  : null; // Everytime a change occurs in the stream, we add a new state
    });
    return switch (result) {
      Success() => emit(MainInitial()),
      Failure() => emit(GetDevicesFailure(message: result.message)),
    };
  }

  void onUpdateEvent(UpdateEvent event, Emitter<MainState> emit) async {
    Result result;
    if (event.flag == 1) {
      result = await deviceRepository.getDevices(event.token);
    } else if (event.flag == 2) {
      result = await deviceRepository.getNotifications(event.token);
    } else {
      result = await deviceRepository.getDevices(event.token);
      result = await deviceRepository.getNotifications(event.token);
    }

    return switch (result) {
      Success() => emit(MainInitial()),
      Failure() => emit(GetDevicesFailure(message: result.message)),
    };
  }

  void onGetDevicesShared(
      MainEventGetDevicesShared event, Emitter<MainState> emit) async {
    var result = await deviceRepository.getDevicesShared(event.token);
    return switch (result) {
      Success() => emit(GetSharedDevicesSuccess()),
      Failure() => emit(GetSharedDevicesFailure(message: result.message)),
    };
  }

  Future<void> onAddDevice(
      MainEventAddDevice event, Emitter<MainState> emit) async {
    final result =
        await deviceRepository.addDevice(event.token, event.name, event.type);
    return switch (result) {
      Success(data: final mes) => emit(AddDeviceSuccess(message: mes)),
      Failure() => emit(AddDeviceFailure(message: result.message)),
    };
  }

  Future<void> onUpdateNameDevice(
      MainEventUpdateNameDevice event, Emitter<MainState> emit) async {
    final result = await deviceRepository.updateNameDevice(
        event.token, event.id, event.name);
    return switch (result) {
      Success(data: final mes) =>
        emit(UpdateDeviceSuccess(message: mes, id: event.id)),
      Failure() => emit(UpdateDeviceFailure(message: result.message)),
    };
  }

  Future<void> onUpdateDevice(
      MainEventUpdateDevice event, Emitter<MainState> emit) async {
    final result = await deviceRepository.updateDataDevice(
        event.token, event.id, event.data);
    return switch (result) {
      Success(data: final mes) =>
        emit(UpdateDeviceSuccess(message: mes, id: event.id)),
      Failure() => emit(UpdateDeviceFailure(message: result.message)),
    };
  }

  Future<void> onDeleteDevice(
      MainEventDeleteDevice event, Emitter<MainState> emit) async {
    emit(MainInitial());
    final result = await deviceRepository.deleteDevice(event.token, event.id);
    return switch (result) {
      Success(data: final mes) =>
        emit(DeleteDeviceSuccess(message: mes, id: event.id)),
      Failure() => emit(DeleteDeviceFailure(message: result.message)),
    };
  }

  Future<void> onShareDevice(
      MainEventShareDevice event, Emitter<MainState> emit) async {
    final result =
        await deviceRepository.shareDevice(event.token, event.id, event.email);
    return switch (result) {
      Success(data: final mes) => emit(
          ShareDeviceSuccess(message: mes, id: event.id, email: event.email)),
      Failure() => emit(ShareDeviceFailure(message: result.message)),
    };
  }

  Future<void> onRevokeShareDevice(
      MainEventRevokeShareDevice event, Emitter<MainState> emit) async {
    final result = await deviceRepository.revokeShareDevice(
        event.token, event.id, event.email);
    return switch (result) {
      Success(data: final mes) =>
        emit(RevokeShareDeviceSuccess(message: mes, id: event.id)),
      Failure() => emit(RevokeShareDeviceFailure(message: result.message)),
    };
  }

  Future<void> onMarkAsRead(
      MainEventMarkAsRead event, Emitter<MainState> emit) async {
    final result = await deviceRepository.markAsRead(event.id, event.token);
    return switch (result) {
      Success(data: final mes) => emit(MarkAsReadSuccess(message: mes)),
      Failure() => emit(MarkAsReadFailure(message: result.message)),
    };
  }

  Future<void> onAddScene(
      MainEventAddScene event, Emitter<MainState> emit) async {
    emit(MainInitial());
  }

  Future<void> onAddSchedule(
      MainEventAddSchedule event, Emitter<MainState> emit) async {
    emit(MainInitial());
    final result = await deviceRepository.addSchedule(
        event.token, event.id, event.days, event.time, event.action,event.last);
    return switch (result) {
      Success(data: final mes) =>
        emit(AddScheduleSuccess(message: mes, id: event.id)),
      Failure() => emit(AddScheduleFailure(message: result.message)),
    };
  }

  Future<void> onDeleteSchedule(
      MainEventDeleteSchedule event, Emitter<MainState> emit) async {
    emit(MainInitial());
    final result = await deviceRepository.deleteSchedule(
        event.token, event.id, event.day, event.actionId);
    return switch (result) {
      Success(data: final mes) =>
        emit(DeleteScheduleSuccess(message: mes, id: event.id)),
      Failure() => emit(DeleteScheduleFailure(message: result.message)),
    };
  }
}

void onSignalUpdate(String message) {
  _webSocketManager.send(message);
}
