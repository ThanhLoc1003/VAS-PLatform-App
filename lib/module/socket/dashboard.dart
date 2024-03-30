import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/socket_dto.dart';

import '../../screens/main/main_screen.dart';
import 'history_page.dart';
import 'more_page.dart';
import 'schedule_page.dart';

late SocketDto socketData;

class DashboardSocket extends StatefulWidget {
  const DashboardSocket({super.key, required this.token, required this.index});

  final int index;
  final String token;
  @override
  State<DashboardSocket> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardSocket> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        try {
          socketData = SocketDto.fromJson(devices[widget.index].toJson());
        } catch (e) {
          Navigator.pop(context);
        }
        final List pageOptions = [
          HomeSocket(index: widget.index, token: widget.token),
          ScheduleSocket(token: widget.token),
          const HistorySocket(),
          const MoreSocket()
        ];

        // print(devices[widget.index].toJson());

        // print(
        //     "Device: ${socketData.type}, ${socketData.json.button1}, ${socketData.json.button2}");
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(socketData.name),
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

class HomeSocket extends StatelessWidget {
  const HomeSocket({super.key, required this.index, required this.token});
  final int index;
  final String token;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        child: ((!socketData.online) || devices[index].jsonData == {})
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
                        socketData.json.button1 = !socketData.json.button1;

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: socketData.id,
                            data: socketData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: socketData.json.button1
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
                        socketData.json.button2 = !socketData.json.button2;

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: socketData.id,
                            data: socketData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: socketData.json.button2
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
                        if (socketData.json.button1 &&
                            socketData.json.button2) {
                          socketData.json.button1 = false;
                          socketData.json.button2 = false;
                        } else {
                          socketData.json.button1 = true;
                          socketData.json.button2 = true;
                        }

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: socketData.id,
                            data: socketData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: socketData.json.button1 && socketData.json.button2
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
