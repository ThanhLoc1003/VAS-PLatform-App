import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';

class LockDto extends DeviceDto {
  final Data json;

  LockDto(
    super.isOn,
      {required super.id,
      required super.name,
      required super.type,
      required this.json,
      required super.online,
      required super.sharedWith,
      required super.jsonData, required super.schedules});

  factory LockDto.fromJson(Map<String, dynamic> json) {
    // print(json);
    return LockDto(
      false,
        json: Data.fromJson(json['data']),
        id: json['_id'].toString(),
        name: json['name'],
        type: json['type'],
        online: json['online'],
        jsonData: {},
        sharedWith: [],
        schedules:  json['schedule']);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> dataJson = json.toJson();
    // final Map<String, dynamic> baseJson = super.toJson();
    return {
      // ...baseJson,
      'data': dataJson,
    };
  }
}

class Data {
  bool button;
  bool state;

  Data({required this.button, required this.state});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      button: json['button'] ?? false,
      state: json['state'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {"button": button, "state": state};
}

