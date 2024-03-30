import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/farm_dto.dart';
import 'package:vas_iot_app/module/irrigation/analytic_page.dart';

import '../../screens/main/main_screen.dart';
import 'history_page.dart';
import 'more_page.dart';
import 'schedule_page.dart';
import 'threshold_page.dart';

late FarmDto farmData;

class DashboardFarm extends StatefulWidget {
  const DashboardFarm({super.key, required this.token, required this.index});

  final int index;
  final String token;
  @override
  State<DashboardFarm> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardFarm> {
  int _selectedIndex = 0;
  String selectedNode = 'Node 1';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        try {
          farmData = FarmDto.fromJson(devices[widget.index].toJson());
        } catch (e) {
          Navigator.pop(context);
        }
        final List pageOptions = [
          HomeFarm(token: widget.token),
          ScheduleFarm(token: widget.token),
          ThresholdFarm(token: widget.token),
          const AnalyticPage(),
          const HistoryFarm(),
          const MoreFarm()
        ];
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(farmData.name),
            actions: [
              DropdownMenu(
                  initialSelection: 'Node 1',
                  onSelected: (value) {
                    setState(() {
                      selectedNode = value!;
                    });
                  },
                  menuStyle: const MenuStyle(
                      shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  )),
                  dropdownMenuEntries: farmData.json.node.map((e) {
                    int index = farmData.json.node.indexOf(e);
                    return DropdownMenuEntry(
                      value: 'Node ${index + 1}',
                      label: 'Node ${index + 1}',
                    );
                  }).toList())
              // IconButton(
              //   tooltip: "Open app settings",
              //   onPressed: () =>
              //       AppSettings.openAppSettings(type: AppSettingsType.wifi),
              //   icon: const Icon(
              //     Icons.link_outlined,
              //     color: Colors.black,
              //   ),
              // ),
            ],
          ),
          body: SafeArea(
            child: pageOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            indicatorColor: Colors.amber,
            selectedIndex: _selectedIndex,
            destinations: <Widget>[
              NavigationDestination(
                selectedIcon: const Icon(Icons.home),
                icon: const Icon(Icons.home_outlined),
                label: 'dashboard'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.schedule_outlined),
                label: 'schedule'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.data_thresholding_rounded),
                label: 'threshold'.tr,
              ),
              NavigationDestination(
                selectedIcon: const Icon(Icons.analytics_outlined),
                icon: const Icon(Icons.analytics_outlined),
                label: 'chart'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.check_box_sharp),
                label: 'history'.tr,
              ),
              NavigationDestination(
                icon: const Icon(Icons.settings),
                label: 'more'.tr,
              ),
            ],
          ),
        );
      },
    );
  }
}

bool isTaped = true;

// ignore: must_be_immutable
class HomeFarm extends StatelessWidget {
  const HomeFarm({super.key, required this.token});
  final String token;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String selectedMode = farmData.json.node[0].mode;

    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        spacing: 30,
        runSpacing: 30,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${"mode".tr}:",
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 40,
              ),
              DropdownMenu(
                  menuStyle: const MenuStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))))),
                  initialSelection: selectedMode,
                  onSelected: (value) {
                    selectedMode = value!;
                    farmData.json.node[0].mode = selectedMode;
                    context.read<MainBloc>().add(MainEventUpdateDevice(
                        token: token,
                        id: farmData.id,
                        data: farmData.toJson()));
                  },
                  dropdownMenuEntries: [
                    DropdownMenuEntry(
                      label: "manual".tr,
                      value: "manual",
                    ),
                    DropdownMenuEntry(
                      label: "auto".tr,
                      value: "auto",
                    ),
                    DropdownMenuEntry(
                      label: "sensor".tr,
                      value: "sensor",
                    ),
                  ]),
            ],
          ),
          SizedBox(
            width: size.width * 0.4,
            height: size.height * 0.3,
            child: SfRadialGauge(
                title: GaugeTitle(
                    text: 'temperature'.tr,
                    textStyle: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                    centerY: 0.4,
                    minimum: 0,
                    maximum: 50,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 20,
                          color: Colors.blue,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 20,
                          endValue: 34,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 34,
                          endValue: 50,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: farmData.json.node[0].sensor.temp,
                        needleLength: 0.4,
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Text('${farmData.json.node[0].sensor.temp}°C',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          angle: 90,
                          positionFactor: 0.7)
                    ],
                  )
                ]),
          ),
          SizedBox(
            width: size.width * 0.4,
            height: size.height * 0.3,
            child: SfRadialGauge(
                title: GaugeTitle(
                    text: 'humidity'.tr,
                    textStyle: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                    centerY: 0.4,
                    minimum: 0,
                    maximum: 100,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 30,
                          color: Colors.green,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 30,
                          endValue: 70,
                          color: Colors.orange,
                          startWidth: 10,
                          endWidth: 10),
                      GaugeRange(
                          startValue: 70,
                          endValue: 100,
                          color: Colors.red,
                          startWidth: 10,
                          endWidth: 10)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                        value: farmData.json.node[0].sensor.humid,
                        needleLength: 0.4,
                      )
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Text('${farmData.json.node[0].sensor.humid}%',
                              style: const TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold)),
                          angle: 90,
                          positionFactor: 0.7)
                    ],
                  )
                ]),
          ),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.42,
              height: size.height * 0.21,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "valve".tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/icons/valve.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Row(
                    children: [
                      Text(
                        "${"status".tr}:",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Switch.adaptive(
                          value: farmData.json.node[0].valve.status,
                          inactiveThumbColor: Colors.grey,
                          onChanged: (value) async {
                            if (isTaped) {
                              isTaped = false;
                              if (selectedMode == "manual") {
                                farmData.json.node[0].valve.status = value;
                                context.read<MainBloc>().add(
                                    MainEventUpdateDevice(
                                        token: token,
                                        id: farmData.id,
                                        data: farmData.toJson()));
                              }
                              await Future.delayed(const Duration(seconds: 3));
                              isTaped = true;
                            }
                          }),
                    ],
                  )
                ],
              )),

          // Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Text(
          //       farmData.online ? "Device is online" : "Device is offline",
          //       style: TextStyle(
          //           color: farmData.online ? Colors.green : Colors.red,
          //           fontSize: 36,
          //           fontWeight: FontWeight.bold),
          //     )),
        ],
      ),
    );
  }
}
