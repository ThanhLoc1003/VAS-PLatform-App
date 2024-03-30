import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/lock_dto.dart';
import 'package:vas_iot_app/module/lock/schedule_page.dart';

import '../../screens/main/main_screen.dart';
import 'history_page.dart';
import 'more_page.dart';

late LockDto lockData;

class DashboardLock extends StatefulWidget {
  const DashboardLock({super.key, required this.token, required this.index});

  final int index;
  final String token;
  @override
  State<DashboardLock> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardLock> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        try {
          lockData = LockDto.fromJson(devices[widget.index].toJson());
        } catch (e) {
          Navigator.pop(context);
        }
        final List pageOptions = [
          Homelock(index: widget.index, token: widget.token),
          ScheduleLock(token: widget.token),
          const HistoryLock(),
          const Morelock()
        ];

        // print(devices[widget.index].toJson());

        // print(
        //     "Device: ${lockData.type}, ${lockData.json.button1}, ${lockData.json.button2}");
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(lockData.name),
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

class Homelock extends StatelessWidget {
  const Homelock({super.key, required this.index, required this.token});
  final int index;
  final String token;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Center(
        child: ((!lockData.online) || devices[index].jsonData == {})
            ? Text("alertDeviceOff".tr,
                style: const TextStyle(fontSize: 26),
                textAlign: TextAlign.center)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Button",
                    style: TextStyle(fontSize: size.height * 0.04),
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (isTaped) {
                        isTaped = false;
                        lockData.json.button = !lockData.json.button;

                        context.read<MainBloc>().add(MainEventUpdateDevice(
                            token: token,
                            id: lockData.id,
                            data: lockData.toJson()));
                        await Future.delayed(const Duration(seconds: 3));
                        isTaped = true;
                      }
                    },
                    child: Image(
                      image: lockData.json.button
                          ? const AssetImage("assets/images/button_on.png")
                          : const AssetImage("assets/images/button_off.png"),
                      height: size.height * 0.2,
                      width: size.height * 0.2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "status".tr,
                    style: TextStyle(fontSize: size.height * 0.04),
                  ),
                  Image(
                    image: lockData.json.state
                        ? const AssetImage("assets/images/open-padlock.png")
                        : const AssetImage("assets/images/padlock.png"),
                    height: size.height * 0.2,
                    width: size.height * 0.2,
                  ),
                ],
              ));
  }
}
