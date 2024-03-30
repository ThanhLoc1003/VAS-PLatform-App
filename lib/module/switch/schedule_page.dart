import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/module/switch/dashboard.dart';

import '../../features/platform/bloc/main_bloc.dart';

class ScheduleSwitch extends StatefulWidget {
  const ScheduleSwitch({super.key, required this.token});
  final String token;

  @override
  State<ScheduleSwitch> createState() => _ScheduleSwitchState();
}

class _ScheduleSwitchState extends State<ScheduleSwitch> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  showSelectDialog() {
    bool action = false;
    List<String> days = [];
    showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              String hour = _selectedTime.hour.toString().padLeft(2, '0');
              String minute = _selectedTime.minute.toString().padLeft(2, '0');

              return AlertDialog(
                backgroundColor: Colors.white,
                title: Text("addNewSchedule".tr,
                    style: const TextStyle(fontSize: 20)),
                actionsAlignment: MainAxisAlignment.spaceBetween,
                actionsOverflowDirection: VerticalDirection.down,
                actions: [
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 148, 199, 222),
                      ),
                      child: ListTile(
                        title: Text(
                          "excecuteControl".tr,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: SwitchListTile.adaptive(
                          inactiveThumbColor: Colors.black,
                          value: action,
                          onChanged: (value) => setState(() => action = value),
                          title: Text(action ? "on".tr : "off".tr),
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: const Color.fromARGB(255, 148, 199, 222),
                      ),
                      child: ListTile(
                        title: Text(
                          "time".tr,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text("at".tr),
                              trailing: ElevatedButton(
                                  onPressed: () async {
                                    final TimeOfDay? timeOfDay =
                                        await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    );
                                    if (timeOfDay != null) {
                                      setState(() {
                                        _selectedTime = timeOfDay;
                                      });
                                    }
                                  },
                                  child: Text("$hour:$minute")),
                            ),
                            ListTile(
                                title: Text("inTheDays".tr),
                                subtitle: Wrap(
                                  spacing: 3,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Monday")) {
                                            days.remove("Monday");
                                          } else {
                                            days.add("Monday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Monday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("M")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Tuesday")) {
                                            days.remove("Tuesday");
                                          } else {
                                            days.add("Tuesday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Tuesday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("T")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Wednesday")) {
                                            days.remove("Wednesday");
                                          } else {
                                            days.add("Wednesday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Wednesday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("W")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Thursday")) {
                                            days.remove("Thursday");
                                          } else {
                                            days.add("Thursday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Thursday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("T")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Friday")) {
                                            days.remove("Friday");
                                          } else {
                                            days.add("Friday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Friday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("F")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Saturday")) {
                                            days.remove("Saturday");
                                          } else {
                                            days.add("Saturday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Saturday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("S")),
                                    ElevatedButton(
                                        onPressed: () {
                                          if (days.contains("Sunday")) {
                                            days.remove("Sunday");
                                          } else {
                                            days.add("Sunday");
                                          }
                                          setState(() {});
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    days.contains("Sunday")
                                                        ? Colors.blue
                                                        : Colors.white)),
                                        child: const Text("S")),
                                  ],
                                )),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.red)),
                          child: Text(
                            "cancel".tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            if (days.isEmpty) {
                              return;
                            }
                            context.read<MainBloc>().add(MainEventAddSchedule(
                                token: widget.token,
                                id: switchData.id,
                                days: days,
                                time: "$hour:$minute",
                                action: action,
                                last: 0));
                            Navigator.pop(context);
                          },
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue)),
                          child: Text(
                            "confirm".tr,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              );
            }));
  }

  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Align(
            alignment: Alignment.topRight,
            child: ElevatedButton(
                onPressed: () => showSelectDialog(),
                child: const Icon(Icons.add, size: 26, color: Colors.black))),
        for (int index = 0; index < days.length; index++)
          Builder(builder: (context) {
            int scheduleIndex =
                switchData.schedules.indexWhere((e) => e.day == days[index]);
            return Container(
              // padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white70,
              ),

              child: ExpansionTile(
                title: Text(days[index].toLowerCase().tr),
                initiallyExpanded: true,
                backgroundColor: Colors.amber[100],
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                children: [
                  if (scheduleIndex != -1)
                    for (int i = 0;
                        i < switchData.schedules[scheduleIndex].actions.length;
                        i++)
                      ListTile(
                        contentPadding:
                            const EdgeInsets.only(left: 65, right: 65),
                        title: Text(
                            switchData.schedules[scheduleIndex].actions[i].time,
                            style: const TextStyle(
                                fontSize: 20, color: Colors.black)),
                        subtitle: Text(
                          switchData.schedules[scheduleIndex].actions[i].action
                              ? "on".tr
                              : "off".tr,
                        ),
                        trailing: IconButton(
                            onPressed: () => context.read<MainBloc>().add(
                                MainEventDeleteSchedule(
                                    token: widget.token,
                                    id: switchData.id,
                                    day: days[index],
                                    actionId: switchData
                                        .schedules[scheduleIndex]
                                        .actions[i]
                                        .id)),
                            icon: const Icon(
                              Icons.delete,
                              size: 26,
                              color: Color(0xFFB71C1C),
                            )),
                      )
                ],
              ),
            );
          })
      ],
    ));
  }
}
