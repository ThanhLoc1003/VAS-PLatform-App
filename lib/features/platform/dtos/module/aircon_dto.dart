import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';

class AirconDto extends DeviceDto {
  final Data json;

  AirconDto(super.isOn,
      {required super.id,
      required super.name,
      required super.type,
      required this.json,
      required super.online,
      required super.sharedWith,
      required super.jsonData,
      required super.schedules});

  factory AirconDto.fromJson(Map<String, dynamic> json) {
    // print(json);
    return AirconDto(false,
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
  bool on;
  String brand;
  int mode;
  int fanSpeed;
  int temp;
  bool swing;

  Data(
      {required this.on,
      required this.brand,
      required this.mode,
      required this.fanSpeed,
      required this.swing,
      required this.temp});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      on: json['on'] ?? false,
      brand: json['brand'] ?? "",
      mode: json['mode'] ?? 0,
      fanSpeed: json['fanSpeed'] ?? 0,
      swing: json['swing'] ?? false,
      temp: json['temp'] ?? 0,
    );
  }
  Map<String, dynamic> toJson() => {
        "on": on,
        "brand": brand,
        "mode": mode,
        "fanSpeed": fanSpeed,
        "swing": swing,
        "temp": temp
      };
}
