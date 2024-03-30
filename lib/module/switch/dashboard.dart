import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/switch_dto.dart';
import 'package:vas_iot_app/module/switch/schedule_page.dart';

import '../../screens/main/main_screen.dart';
import 'history_page.dart';
import 'more_page.dart';

late SwitchDto switchData;

class DashboardSwitch extends StatefulWidget {
  const DashboardSwitch({super.key, required this.token, required this.index});

  final int index;
  final String token;
  @override
  State<DashboardSwitch> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardSwitch> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        try {
          switchData = SwitchDto.fromJson(devices[widget.index].toJson());

          // print("Device: ${switchData.schedules[0].toJson()}");
        } catch (e) {
          Navigator.pop(context);
        }
        final List pageOptions = [
          HomeSwitch(index: widget.index, token: widget.token),
          ScheduleSwitch(token: widget.token),
          const HistorySwitch(),
          const MoreSwitch()
        ];

        // print(devices[widget.index].toJson());

        // print(
        //     "Device: ${switchData.type}, ${switchData.json.button1}, ${switchData.json.button2}");
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(switchData.name),
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

class HomeSwitch extends StatelessWidget {
  const HomeSwitch({super.key, required this.index, required this.token});
  final int index;
  final String token;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        child: ((!switchData.online) || devices[index].jsonData == {})
            ? Text("alertDeviceOff".tr,
                style: const TextStyle(fontSize: 26),
                textAlign: TextAlign.center)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Button 1",
                    style: TextStyle(fontSize: size.height * 0.04),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isTaped) {
                        isTaped = false;
                        switchData.json.button1 = !switchData.json.button1;

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: switchData.id,
                            data: switchData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: switchData.json.button1
                          ? const AssetImage("assets/images/button_on.png")
                          : const AssetImage("assets/images/button_off.png"),
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Button 2",
                    style: TextStyle(fontSize: size.height * 0.04),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isTaped) {
                        isTaped = false;
                        switchData.json.button2 = !switchData.json.button2;

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: switchData.id,
                            data: switchData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: switchData.json.button2
                          ? const AssetImage("assets/images/button_on.png")
                          : const AssetImage("assets/images/button_off.png"),
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                    ),
                  ),
                  Text(
                    "Both",
                    style: TextStyle(fontSize: size.height * 0.04),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isTaped) {
                        isTaped = false;
                        if (switchData.json.button1 &&
                            switchData.json.button2) {
                          switchData.json.button1 = false;
                          switchData.json.button2 = false;
                        } else {
                          switchData.json.button1 = true;
                          switchData.json.button2 = true;
                        }

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: switchData.id,
                            data: switchData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: switchData.json.button1 && switchData.json.button2
                          ? const AssetImage("assets/images/button_on.png")
                          : const AssetImage("assets/images/button_off.png"),
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                    ),
                  ),
                ],
              ));
  }
}
