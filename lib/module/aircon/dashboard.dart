import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/aircon_dto.dart';

import '../../screens/main/main_screen.dart';
import 'history_page.dart';
import 'more_page.dart';
import 'schedule_page.dart';

late AirconDto airconData;

class DashboardAircon extends StatefulWidget {
  const DashboardAircon({super.key, required this.token, required this.index});

  final int index;
  final String token;
  @override
  State<DashboardAircon> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardAircon> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        try {
          airconData = AirconDto.fromJson(devices[widget.index].toJson());

          // print("Device: ${AirconData.schedules[0].toJson()}");
        } catch (e) {
          Navigator.pop(context);
        }
        final List pageOptions = [
          HomeAircon(token: widget.token),
          ScheduleAircon(token: widget.token),
          const HistoryAircon(),
          const MoreAircon()
        ];

        // print(devices[widget.index].toJson());

        // print(
        //     "Device: ${AirconData.type}, ${AirconData.json.button1}, ${AirconData.json.button2}");
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(airconData.name),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.info_outline_rounded,
                    color: Colors.black,
                  )),
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
                selectedIcon: const Icon(Icons.schedule_outlined),
                icon: const Icon(Icons.schedule_outlined),
                label: 'schedule'.tr,
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

class HomeAircon extends StatelessWidget {
  const HomeAircon({super.key, required this.token});
  final String token;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        child: ((!airconData.online) || (airconData.json.brand == ""))
            ? Text("alertDeviceOff".tr,
                style: const TextStyle(fontSize: 26),
                textAlign: TextAlign.center)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    airconData.json.brand,
                    style: TextStyle(fontSize: size.height * 0.04),
                  ),
                  const SizedBox(height: 20),
                  Text("${airconData.json.temp}°C",
                      style: TextStyle(fontSize: size.height * 0.13)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () async {
                            if (isTaped) {
                              isTaped = false;
                              airconData.json.temp = airconData.json.temp - 1;
                              context.read<MainBloc>().add(
                                  MainEventUpdateDevice(
                                      token: token,
                                      id: airconData.id,
                                      data: airconData.toJson()));
                              await Future.delayed(const Duration(seconds: 3));
                              isTaped = true;
                            }
                          },
                          icon: Icon(Icons.remove, size: size.height * 0.08)),
                      const Divider(),
                      IconButton(
                          onPressed: () async {
                            if (isTaped) {
                              isTaped = false;
                              airconData.json.temp = airconData.json.temp + 1;
                              context.read<MainBloc>().add(
                                  MainEventUpdateDevice(
                                      token: token,
                                      id: airconData.id,
                                      data: airconData.toJson()));
                              await Future.delayed(const Duration(seconds: 3));
                              isTaped = true;
                            }
                          },
                          icon: Icon(Icons.add, size: size.height * 0.08)),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isTaped) {
                        isTaped = false;
                        airconData.json.on = !airconData.json.on;
                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: airconData.id,
                            data: airconData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: airconData.json.on
                          ? const AssetImage("assets/images/button_on.png")
                          : const AssetImage("assets/images/button_off.png"),
                      height: size.height * 0.1,
                      width: size.height * 0.1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.swipe_outlined),
                          label: Text("fanSpeed".tr)),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              airconData.json.fanSpeed == 1
                                  ? Colors.green
                                  : Colors.white),
                        ),
                        child: const Text("1"),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              airconData.json.fanSpeed == 2
                                  ? Colors.green
                                  : Colors.white),
                        ),
                        child: const Text("2"),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              airconData.json.fanSpeed == 3
                                  ? Colors.green
                                  : Colors.white),
                        ),
                        child: const Text("3"),
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              airconData.json.fanSpeed == 4
                                  ? Colors.green
                                  : Colors.white),
                        ),
                        child: const Text("4"),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 20,
                      ),
                      TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.sunny_snowing),
                          label: Text("turbo".tr)),
                      const Spacer(),
                      Switch.adaptive(
                          value: airconData.json.swing,
                          inactiveThumbColor: const Color(0xFF4e5ae8),
                          activeTrackColor: Colors.blue,
                          onChanged: (value) async {
                            if (isTaped) {
                              isTaped = false;
                              airconData.json.swing = value;
                              context.read<MainBloc>().add(
                                  MainEventUpdateDevice(
                                      token: token,
                                      id: airconData.id,
                                      data: airconData.toJson()));
                              await Future.delayed(const Duration(seconds: 3));
                              isTaped = true;
                            }
                          }),
                      const SizedBox(
                        width: 20,
                      )
                    ],
                  )
                ],
              ));
  }
}
