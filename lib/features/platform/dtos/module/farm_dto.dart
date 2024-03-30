import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';

class FarmDto extends DeviceDto {
  final Data json;

  FarmDto(super.isOn,
      {required super.id,
      required super.name,
      required super.type,
      required this.json,
      required super.online,
      required super.sharedWith,
      required super.jsonData,
      required super.schedules});

  factory FarmDto.fromJson(Map<String, dynamic> json) {
    // print(json['data']);
    return FarmDto(false,
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
  List<Node> node;

  Data({required this.node});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      node: List.from(json['node'])
          .map((e) => Node.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {"node": node};
}

class Node {
  final String id;
  Threshold threshold;
  String mode;
  Sensor sensor;
  Valve valve;

  Node({
    required this.id,
    required this.threshold,
    required this.mode,
    required this.sensor,
    required this.valve,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    // print(json['sensor']);
    return Node(
      id: json['_id'] ?? '',
      threshold: Threshold.fromJson(json['threshold'] ?? {}),
      mode: json['mode'] ?? '',
      sensor: Sensor.fromJson(json['sensor'] ?? {}),
      valve: Valve.fromJson(json['valve'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'threshold': threshold.toJson(),
        'mode': mode,
        'sensor': sensor,
        'valve': valve,
      };

  Node copyWith({
    Threshold? threshold,
    String? mode,
    Sensor? sensor,
    Valve? valve,
  }) =>
      Node(
        id: id,
        threshold: threshold ?? this.threshold,
        mode: mode ?? this.mode,
        sensor: sensor ?? this.sensor,
        valve: valve ?? this.valve,
      );
}

class Sensor {
  int id;
  double humid;
  double temp;

  Sensor({
    required this.id,
    required this.humid,
    required this.temp,
  });

  Sensor copyWith({
    int? id,
    double? humid,
    double? temp,
  }) =>
      Sensor(
        id: id ?? this.id,
        humid: humid ?? this.humid,
        temp: temp ?? this.temp,
      );
  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['_id'] ?? 0,
      humid: double.parse((json['humid'] ?? 0).toString()),
      temp: double.parse((json['temp'] ?? 0).toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'humid': humid,
        'temp': temp,
      };
}

class Threshold {
  int humid;
  int temp;

  Threshold({
    required this.humid,
    required this.temp,
  });

  factory Threshold.fromJson(Map<String, dynamic> json) {
    return Threshold(
      humid: json['humid'] ?? 0,
      temp: json['temp'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "humid": humid,
        "temp": temp,
      };

  Threshold copyWith({
    int? humid,
    int? temp,
  }) =>
      Threshold(
        humid: humid ?? this.humid,
        temp: temp ?? this.temp,
      );
}

class Valve {
  int id;
  bool status;

  Valve({
    required this.id,
    required this.status,
  });

  factory Valve.fromJson(Map<String, dynamic> json) {
    return Valve(
      id: json['_id'] ?? 0,
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'status': status,
      };

  Valve copyWith({
    int? id,
    bool? status,
  }) =>
      Valve(
        id: id ?? this.id,
        status: status ?? this.status,
      );
}
