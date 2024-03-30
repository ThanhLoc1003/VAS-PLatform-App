part of 'main_bloc.dart';

sealed class MainEvent {
  final String token;

  MainEvent({required this.token});
}

class MainEventStarted extends MainEvent {
  MainEventStarted({required super.token});
}

class UpdateEvent extends MainEvent {
  int flag;
  UpdateEvent({required super.token, required this.flag});
}

class MainEventGetDevicesShared extends MainEvent {
  MainEventGetDevicesShared({required super.token});
}

class MainEventAddDevice extends MainEvent {
  final String name;
  final String type;
  MainEventAddDevice(
      {required super.token, required this.name, required this.type});
}

class MainEventUpdateNameDevice extends MainEvent {
  final String id;
  final String name;

  MainEventUpdateNameDevice({
    required super.token,
    required this.id,
    required this.name,
  });
}

class MainEventUpdateDevice extends MainEvent {
  final String id;

  final Map<String, dynamic> data;
  MainEventUpdateDevice({
    required super.token,
    required this.id,
    required this.data,
  });
}

class MainEventDeleteDevice extends MainEvent {
  final String id;
  MainEventDeleteDevice({required super.token, required this.id});
}

class MainEventShareDevice extends MainEvent {
  final String id;
  final String email;
  MainEventShareDevice(
      {required super.token, required this.id, required this.email});
}

class MainEventRevokeShareDevice extends MainEvent {
  final String id;
  final String email;
  MainEventRevokeShareDevice(
      {required super.token, required this.id, required this.email});
}

class MainEventMarkAsRead extends MainEvent {
  final String id;
  MainEventMarkAsRead({required this.id, required super.token});
}

class MainEventAddScene extends MainEvent {
  MainEventAddScene({required super.token});
}

class MainEventAddSchedule extends MainEvent {
  final String id;
  final List<String> days;
  final String time;
  final bool action;
  final int last;
  MainEventAddSchedule(
      {required super.token,
      required this.id,
      required this.days,
      required this.time,
      required this.action,
      required this.last});
}

class MainEventDeleteSchedule extends MainEvent {
  final String id;
  final String day;
  final String actionId;
  MainEventDeleteSchedule(
      {required super.token,
      required this.id,
      required this.day,
      required this.actionId});
}
