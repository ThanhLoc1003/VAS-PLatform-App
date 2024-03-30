part of 'main_bloc.dart';

sealed class MainState {}

final class MainInitial extends MainState {}

final class GetDevicesFailure extends MainState {
  final String message;
  GetDevicesFailure({required this.message});
}

final class GetSharedDevicesSuccess extends MainState {}

final class GetSharedDevicesFailure extends MainState {
  final String message;
  GetSharedDevicesFailure({required this.message});
}

final class AddDeviceSuccess extends MainState {
  final String message;

  AddDeviceSuccess({required this.message});
}

final class AddDeviceFailure extends MainState {
  final String message;

  AddDeviceFailure({required this.message});
}

final class UpdateDeviceSuccess extends MainState {
  final String message;
  final String id;
  UpdateDeviceSuccess({required this.message, required this.id});
}

final class UpdateDeviceFailure extends MainState {
  final String message;

  UpdateDeviceFailure({required this.message});
}

final class DeleteDeviceSuccess extends MainState {
  final String message;
  final String id;
  DeleteDeviceSuccess({required this.message, required this.id});
}

final class DeleteDeviceFailure extends MainState {
  final String message;

  DeleteDeviceFailure({required this.message});
}

final class ShareDeviceSuccess extends MainState {
  final String message;
  final String email;
  final String id;
  ShareDeviceSuccess(
      {required this.message, required this.id, required this.email});
}

final class ShareDeviceFailure extends MainState {
  final String message;

  ShareDeviceFailure({required this.message});
}

final class RevokeShareDeviceSuccess extends MainState {
  final String message;

  final String id;

  RevokeShareDeviceSuccess({required this.message, required this.id});
}

final class RevokeShareDeviceFailure extends MainState {
  final String message;

  RevokeShareDeviceFailure({required this.message});
}

final class MarkAsReadSuccess extends MainState {
  final String message;

  MarkAsReadSuccess({required this.message});
}

final class MarkAsReadFailure extends MainState {
  final String message;

  MarkAsReadFailure({required this.message});
}

final class AddScheduleSuccess extends MainState {
  final String message;
  final String id;

  AddScheduleSuccess({required this.message, required this.id});
}

final class AddScheduleFailure extends MainState {
  final String message;

  AddScheduleFailure({required this.message});
}

final class DeleteScheduleSuccess extends MainState {
  final String message;
  final String id;

  DeleteScheduleSuccess({required this.message, required this.id});
}

final class DeleteScheduleFailure extends MainState {
  final String message;

  DeleteScheduleFailure({required this.message});
}
