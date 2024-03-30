import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/module/sensor_dto.dart';
import 'package:vas_iot_app/module/sensor/analytic_page.dart';

import '../../screens/main/main_screen.dart';
import 'history_page.dart';
import 'more_page.dart';

late SensorDto sensorData;

class DashboardSensor extends StatefulWidget {
  const DashboardSensor({super.key, required this.token, required this.index});

  final int index;
  final String token;
  @override
  State<DashboardSensor> createState() => _DashboardState();
}

class _DashboardState extends State<DashboardSensor> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        try {
          sensorData = SensorDto.fromJson(devices[widget.index].toJson());
        } catch (e) {
          Navigator.pop(context);
        }
        final List pageOptions = [
          HomeSensor(token: widget.token),
          const AnalyticPage(),
          const HistorySensor(),
          const MoreSensor()
        ];
        return Scaffold(
          backgroundColor: Colors.indigo[50],
          appBar: AppBar(
            title: Text(sensorData.name),
            actions: [
              IconButton(
                tooltip: "Open app settings",
                onPressed: () =>
                    AppSettings.openAppSettings(type: AppSettingsType.wifi),
                icon: const Icon(
                  Icons.link_outlined,
                  color: Colors.black,
                ),
              ),
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

class HomeSensor extends StatelessWidget {
  const HomeSensor({super.key, required this.token});
  final String token;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 30),
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 30,
        runSpacing: 30,
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "temperature".tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/images/hot.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Text(
                    "${sensorData.json.temp}°C",
                    style: const TextStyle(fontSize: 26),
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "humidity".tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/images/humidity.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Text(
                    "${sensorData.json.humid}%",
                    style: const TextStyle(fontSize: 26),
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "CO2",
                    style: TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/images/co2.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Text(
                    "${sensorData.json.co2.ceilToDouble()}ppm",
                    style: const TextStyle(fontSize: 26),
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "UV",
                    style: TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/images/uv.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Text(
                    "${sensorData.json.uv.ceilToDouble()}",
                    style: const TextStyle(fontSize: 26),
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Noise",
                    style: TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/images/noise.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Text(
                    "${sensorData.json.noise.ceilToDouble()}dB",
                    style: const TextStyle(fontSize: 26),
                  ),
                ],
              )),
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white70),
              width: size.width * 0.4,
              height: size.height * 0.2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "PM25",
                    style: TextStyle(fontSize: 20),
                  ),
                  Image.asset("assets/images/dust.png",
                      height: size.height * 0.12, width: size.height * 0.2),
                  Text(
                    "${sensorData.json.pm25.ceilToDouble()}ug/m3",
                    style: const TextStyle(fontSize: 26),
                  ),
                ],
              )),
          // Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Text(
          //       sensorData.online ? "Device is online" : "Device is offline",
          //       style: TextStyle(
          //           color: sensorData.online ? Colors.green : Colors.red,
          //           fontSize: 36,
          //           fontWeight: FontWeight.bold),
          //     ))
        ],
      ),
    );
  }
}
