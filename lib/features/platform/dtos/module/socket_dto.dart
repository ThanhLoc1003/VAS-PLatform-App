import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';

class SocketDto extends DeviceDto {
  final Data json;

  SocketDto(super.isOn,
      {required super.id,
      required super.name,
      required super.type,
      required this.json,
      required super.online,
      required super.sharedWith,
      required super.jsonData,
      required super.schedules});

  factory SocketDto.fromJson(Map<String, dynamic> json) {
    // print(json);
    return SocketDto(false,
        json: Data.fromJson(json['data']),
        id: json['_id'].toString(),
        name: json['name'],
        type: json['type'],
        online: json['online'],
        jsonData: {},
        sharedWith: [],
        schedules: json['schedule']);
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
  bool button1;
  bool button2;

  Data({required this.button1, required this.button2});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      button1: json['button1'] ?? false,
      button2: json['button2'] ?? false,
    );
  }
  Map<String, dynamic> toJson() => {"button1": button1, "button2": button2};
}
