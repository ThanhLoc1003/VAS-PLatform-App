class DeviceDto {
  final String id;
  final String name;
  final String type;
  final bool online;
  final List<String> sharedWith;
  final Map<String, dynamic> jsonData;
  final List<ScheduleDto> schedules;

  bool isOn = false;
  DeviceDto(this.isOn,
      {required this.id,
      required this.name,
      required this.type,
      required this.online,
      required this.sharedWith,
      required this.jsonData,
      required this.schedules});
  DeviceDto copyWith() {
    return DeviceDto(isOn,
        id: id,
        name: name,
        type: type,
        online: online,
        sharedWith: sharedWith,
        jsonData: jsonData,
        schedules: schedules);
  }

  factory DeviceDto.fromJson(Map<String, dynamic> json) {
    // print(json['schedule']);
    // List.from(json['schedule'] ?? []).map((x) => print(x.toString())).toList();
    // if (test.isNotEmpty) {
    //   print(test[0]);
    // }
    var data = DeviceDto(json['isOn'] ?? false,
        sharedWith: List<String>.from(json['sharedWith'] ?? []),
        id: json['_id'].toString(),
        name: json['name'],
        type: json['type'],
        online: json['online'],
        jsonData: json['data'] ?? {},
        schedules: List.from(json['schedule'] ?? [])
            .map((e) => ScheduleDto.fromJson(e as Map<String, dynamic>))
            .toList());

    return data;
  }
  Map<String, dynamic> toJson() => {
        "isOn": isOn,
        "_id": id,
        "name": name,
        "type": type,
        "online": online,
        "data": jsonData,
        "schedule": schedules
      };
}

class ScheduleDto {
  final String day;
  final String id;
  final List<ActionDto> actions;

  ScheduleDto({required this.day, required this.id, required this.actions});

  factory ScheduleDto.fromJson(Map<String, dynamic> json) {
    // print("Đổi khởi động: " + json['day']);
    // print("schedule: " + json['actions']);
    var data = List.from(json['actions'] ?? [])
        .map((e) => ActionDto.fromJson(e as Map<String, dynamic>))
        .toList();
    data.sort((a, b) => a.time.compareTo(b.time));
    return ScheduleDto(
        day: json['day'] ?? "", id: json['_id'] ?? "", actions: data);
  }
  Map<String, dynamic> toJson() => {"day": day, "_id": id, "actions": actions};
}

class ActionDto {
  final String time;
  final bool action;
  final String id;
  final int last;

  ActionDto(
      {required this.time,
      required this.action,
      required this.last,
      required this.id});
  factory ActionDto.fromJson(Map<String, dynamic> json) {
    return ActionDto(
        time: json['time'] ?? "",
        action: json['action'] ?? false,
        last: json['last'] ?? 0,
        id: json['_id'] ?? "".toString());
  }

  Map<String, dynamic> toJson() =>
      {"time": time, "action": action, "last": last, "_id": id};
}
