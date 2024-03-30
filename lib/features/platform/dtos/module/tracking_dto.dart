import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';

class TrackingDto extends DeviceDto {
  final Data json;

  TrackingDto(super.isOn,
      {required super.id,
      required super.name,
      required super.type,
      required this.json,
      required super.online,
      required super.sharedWith,
      required super.jsonData,
      required super.schedules});

  factory TrackingDto.fromJson(Map<String, dynamic> json) {
    // print(json);
    return TrackingDto(false,
        json: Data.fromJson(json['data']),
        id: json['_id'].toString(),
        name: json['name'],
        type: json['type'],
        online: json['online'],
        jsonData: {},
        sharedWith: [],
        schedules: json['schedule']);
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
  double lat;
  double long;

  Data({required this.lat, required this.long});
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(lat: json['latitude'] ?? 0.0, long: json['longitude'] ?? 0.0);
  }
  // Map<String, dynamic> toJson() => {"button1": button1, "button2": button2};
}
// class Data {
//   final double humid;
//   final double temp;

//   Data({required this.humid, required this.temp});
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       humid: json['humid'] ?? 0.0,
//       temp: json['temp'] ?? 0.0,
//     );
//   }
//   Map<String, dynamic> toJson() => {"humid": humid, "temp": temp};
// }
