import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';

class SensorDto extends DeviceDto {
  final Data json;

  SensorDto(super.isOn,
      {required super.id,
      required super.name,
      required super.type,
      required this.json,
      required super.online,
      required super.sharedWith,
      required super.jsonData,
      required super.schedules});

  factory SensorDto.fromJson(Map<String, dynamic> json) {
    // print(json);
    return SensorDto(false,
        json: Data.fromJson(json['data']),
        id: json['_id'].toString(),
        name: json['name'],
        type: json['type'],
        online: json['online'],
        jsonData: {},
        sharedWith: [],
        schedules: []);
  }

  // @override
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> dataJson = json.toJson();
  //   // final Map<String, dynamic> baseJson = super.toJson();
  //   return {
  //     // ...baseJson,
  //     'data': dataJson,
  //   };
  // }
}

class Data {
  final double humid;
  final double temp;
  final double light;
  final double co2;
  final double tvoc;
  final double pm25;
  final double pm10;
  final double noise;
  final double uv;

  Data(this.light, this.co2, this.tvoc, this.pm25, this.pm10, this.noise,
      this.uv,
      {required this.humid, required this.temp});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      double.parse((json['light'] ?? 0.0).toString()),
      double.parse((json['co2'] ?? 0.0).toString()),
      double.parse((json['tvoc'] ?? 0.0).toString()),
      double.parse((json['pm25'] ?? 0.0).toString()),
      double.parse((json['pm10'] ?? 0.0).toString()),
      double.parse((json['noise'] ?? 0.0).toString()),
      double.parse((json['uv'] ?? 0.0).toString()),
      humid: double.parse((json['humid'] ?? 0.0).toString()),
      temp: double.parse((json['temp'] ?? 0.0).toString()),
    );
  }
  // Map<String, dynamic> toJson() => {"humid": humid, "temp": temp};
}
