import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/aircon_dto.dart';
import 'package:vas_iot_app/features/platform/dtos/module/farm_dto.dart';
import 'package:vas_iot_app/features/platform/dtos/module/gate_dto.dart';
import 'package:vas_iot_app/features/platform/dtos/module/lock_dto.dart';
import 'package:vas_iot_app/features/platform/dtos/module/socket_dto.dart';

import '../../features/platform/dtos/device_dto.dart';
import '../../features/platform/dtos/module/switch_dto.dart';

class Situation {
  String name;
  List<DeviceDto> devices;

  Situation({required this.name, required this.devices});

  // Phương thức copyWith() để tạo bản sao của Situation
  Situation copyWith({String? name, List<DeviceDto>? devices}) {
    return Situation(
      // Sử dụng giá trị mới nếu được chỉ định, nếu không sử dụng giá trị hiện tại
      name: name ?? this.name,
      devices:
          List<DeviceDto>.from(this.devices.map((device) => device.copyWith())),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'devices': devices.map((device) => device.toJson()).toList(),
    };
  }

  factory Situation.fromJson(Map<String, dynamic> json) {
    return Situation(
      name: json['name'],
      devices: List<DeviceDto>.from(
          json['devices'].map((deviceJson) => DeviceDto.fromJson(deviceJson))),
    );
  }
}

// ignore: must_be_immutable
class ScenePage extends StatefulWidget {
  ScenePage({super.key, required this.token, required this.devices});
  String token;
  List<DeviceDto> devices;
  @override
  State<ScenePage> createState() => _ScenePageState();
}

class _ScenePageState extends State<ScenePage> {
  List<Situation> situations = [];

  @override
  void initState() {
    super.initState();
    _loadSituations();
  }

  _loadSituations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? situationsJsonList = prefs.getStringList('situations');
    if (situationsJsonList != null) {
      setState(() {
        situations = situationsJsonList
            .map((jsonString) => Situation.fromJson(jsonDecode(jsonString)))
            .toList();
      });
    }
  }

  _saveSituations(List<Situation> situations) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('situations');
    List<String> situationsJsonList =
        situations.map((situation) => jsonEncode(situation.toJson())).toList();
    await prefs.setStringList('situations', situationsJsonList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: ElevatedButton(
            onPressed: () {
              _addSituationDialog(context);
            },
            child: const Icon(Icons.add),
          ),
        ),
        for (var situation in situations)
          Container(
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                )),
            child: ListTile(
              title: Text(situation.name),
              trailing: PopupMenuButton(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        onTap: () {
                          int index = situations.indexOf(situation);
                          var editSituation = situation.copyWith(
                              name: situation.name, devices: situation.devices);
                          // print("Edit: ${editSituation.devices.length}");
                          // editSituation.devices[0].isOn = true;
                          // print(
                          //     "Edit: ${situation.devices[0].isOn} // ${editSituation.devices[0].isOn}");
                          _editSituationDialog(context, index, editSituation);
                        },
                        child: Text('edit'.tr),
                      ),
                      PopupMenuItem(
                        onTap: () {
                          setState(() {
                            situations.remove(situation);
                          });
                          _saveSituations(situations);
                        },
                        child: Text('delete'.tr),
                      )
                    ];
                  }),
              onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text("toDoNotification".tr),
                      actionsAlignment: MainAxisAlignment.spaceBetween,
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'cancel'.tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _confirmScene(situation);
                          },
                          child: Text(
                            'confirm'.tr,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
        const Spacer(),
        const SizedBox(height: 80),
      ],
    );
  }

  _confirmScene(Situation situation) {
    for (var device in situation.devices) {
      if (device.online) {
        switch (device.type) {
          case "Switch":
            var switchData = SwitchDto.fromJson(device.toJson());
            if (device.isOn) {
              switchData.json.button1 = true;
              switchData.json.button2 = true;
            } else {
              switchData.json.button1 = false;
              switchData.json.button2 = false;
            }
            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token,
                id: switchData.id,
                data: switchData.toJson()));
            break;
          case "Socket":
            var data = SocketDto.fromJson(device.toJson());
            if (device.isOn) {
              data.json.button1 = true;
              data.json.button2 = true;
            } else {
              data.json.button1 = false;
              data.json.button2 = false;
            }
            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token, id: data.id, data: data.toJson()));
            break;
          case "Lock":
            var data = LockDto.fromJson(device.toJson());
            (device.isOn) ? data.json.button = true : data.json.button = false;
            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token, id: data.id, data: data.toJson()));
          case "Gate":
            var data = GateDto.fromJson(device.toJson());
            if (device.isOn) {
              data.json.button1 = true;
              data.json.button2 = true;
            } else {
              data.json.button1 = false;
              data.json.button2 = false;
            }
            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token, id: data.id, data: data.toJson()));

            break;
          case "Irrigation":
            var data = FarmDto.fromJson(device.toJson());
            (device.isOn)
                ? data.json.node[0].valve.status = true
                : data.json.node[0].valve.status = false;
            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token, id: data.id, data: data.toJson()));
          case "Aircon":
            var data = AirconDto.fromJson(device.toJson());
            (device.isOn) ? data.json.on = true : data.json.on = false;
            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token, id: data.id, data: data.toJson()));
          default:
            break;
        }
      }
    }
  }

  Future<void> _addSituationDialog(BuildContext context) async {
    String newSituation = '';
    List<DeviceDto> selectedDevices = [];

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('${"add".tr} ${"scene".tr.toLowerCase()}'),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        newSituation = value;
                      },
                      decoration: InputDecoration(
                        hintText:
                            '${"input".tr} ${"name".tr.toLowerCase()} ${"scene".tr.toLowerCase()}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('devices'.tr),
                    for (var device in widget.devices)
                      if ((device.type != "Sensor") &&
                          (device.type != "Energy") &&
                          (device.type != "Tracking"))
                        CheckboxListTile(
                          title: Text(device.name),
                          value: selectedDevices.contains(device),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          tristate: false,
                          secondary: selectedDevices.contains(device)
                              ? Switch.adaptive(
                                  inactiveThumbColor: Colors.black,
                                  value: device.isOn,
                                  onChanged: (value) {
                                    setState(() {
                                      device.isOn = value;
                                    });
                                  })
                              : null,
                          onChanged: (value) {
                            if (value!) {
                              selectedDevices.add(device);
                            } else {
                              selectedDevices.remove(device);
                            }
                            setState(() {});
                          },
                        ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    if (newSituation.isEmpty) {
                      newSituation = 'Custom ${situations.length + 1}';
                    }
                    setState(() {
                      situations.add(Situation(
                          name: newSituation, devices: selectedDevices));
                    });
                    _saveSituations(situations);
                    context
                        .read<MainBloc>()
                        .add(MainEventAddScene(token: "fdgdfg"));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'add'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _editSituationDialog(
    BuildContext context,
    int index,
    Situation situation,
  ) async {
    String editSituation = situation.name;

    List<DeviceDto> selectedDevices = List.from(situation.devices);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text('${"edit".tr} ${"scene".tr.toLowerCase()}'),
              content: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        editSituation = value;
                      },
                      decoration: InputDecoration(
                        hintText:
                            '${"input".tr} ${"name".tr.toLowerCase()} ${"scene".tr.toLowerCase()}',
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('devices'.tr),
                    for (var device in situation.devices)
                      if (true)
                        CheckboxListTile(
                          title: Text(device.name),
                          value: selectedDevices.contains(device),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.green,
                          checkColor: Colors.white,
                          tristate: false,
                          secondary: selectedDevices.contains(device)
                              ? Switch.adaptive(
                                  inactiveThumbColor: Colors.black,
                                  value: selectedDevices
                                      .elementAt(
                                          selectedDevices.indexOf(device))
                                      .isOn,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedDevices
                                          .elementAt(
                                              selectedDevices.indexOf(device))
                                          .isOn = value;
                                    });
                                  })
                              : null,
                          onChanged: (value) {
                            if (value!) {
                              selectedDevices.add(device);
                            } else {
                              selectedDevices.remove(device);
                            }
                            setState(() {});
                          },
                        ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'cancel'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    setState(() {
                      situations.removeAt(index);
                      situations.insert(
                          index,
                          Situation(
                              name: editSituation, devices: selectedDevices));
                    });
                    _saveSituations(situations);
                    context
                        .read<MainBloc>()
                        .add(MainEventAddScene(token: "fdgdfg"));
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'save'.tr,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
