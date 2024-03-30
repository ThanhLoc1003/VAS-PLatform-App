import 'dart:developer';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/dtos/device_dto.dart';
import 'package:vas_iot_app/screens/message/message_screen.dart';
import 'package:vas_iot_app/screens/setting/setting_screen.dart';
import 'package:weather/weather.dart';

import '../../features/auth/data/auth_local_data_source.dart';
import '../../features/platform/dtos/notification_dto.dart';
import '../home/home_screen.dart';
import '../scene/scene_screen.dart';
import 'package:flutter_close_app/flutter_close_app.dart';

List<DeviceDto> devices = [];
List<NotificationDto> notifications = [];
String email = "";
bool isLoadedWeather = false;
  late Weather  dataWeather;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  String token = '';

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    final sf = await SharedPreferences.getInstance();
    var authLocalDataSource = AuthLocalDataSource(sf);
    token = (await authLocalDataSource.getToken())!;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    email = decodedToken['email'];
    try {
      // ignore: use_build_context_synchronously
      context.read<MainBloc>().add(MainEventStarted(token: token));
    } catch (e) {
      // print(e);
      FlutterCloseApp.close();
    }
  }

  void showRetryConnect() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Text("Error"),
            content: const Text("Can not connect to server"),
            actions: [
              ElevatedButton(
                  onPressed: () => context
                      .read<MainBloc>()
                      .add(MainEventStarted(token: token)),
                  child: const Text(
                    "Retry",
                  ))
            ],
          );
        });
  }

  void showMessageSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: const StadiumBorder(),
      backgroundColor: Colors.greenAccent.shade400,
      duration: const Duration(seconds: 2),
    ));
  }

  void showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$message. Please try again"),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: const StadiumBorder(),
      backgroundColor: Colors.red.shade300,
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        switch (state) {
          case MainInitial():
            break;
          case GetDevicesFailure():
            showRetryConnect();
            break;
          case GetSharedDevicesSuccess():
            break;
          case GetSharedDevicesFailure():
            showMessageSnackBar(context, state.message);
            break;
          case AddDeviceSuccess():
            context.read<MainBloc>().add(UpdateEvent(token: token, flag: 1));
            showMessageSnackBar(context, state.message);
            break;
          case AddDeviceFailure():
            showErrorSnackBar(context, state.message);
            break;
          case AddScheduleSuccess():
            onSignalUpdate(state.id);
            showMessageSnackBar(context, state.message);
            break;
          case AddScheduleFailure():
            showErrorSnackBar(context, state.message);
            break;
          case DeleteScheduleSuccess():
            onSignalUpdate(state.id);
            showMessageSnackBar(context, state.message);
            break;
          case DeleteScheduleFailure():
            showErrorSnackBar(context, state.message);
            break;
          case ShareDeviceSuccess():
            onSignalUpdate("${state.email}-share");
            break;
          case ShareDeviceFailure():
            showErrorSnackBar(context, state.message);
            break;
          case UpdateDeviceSuccess():
            onSignalUpdate(state.id);
            showMessageSnackBar(context, state.message);
            break;
          case UpdateDeviceFailure():
            showErrorSnackBar(context, state.message);
            break;
          case DeleteDeviceSuccess():
            onSignalUpdate(state.id);

            showMessageSnackBar(context, state.message);
            break;
          case DeleteDeviceFailure():
            showErrorSnackBar(context, state.message);
            break;
          case MarkAsReadSuccess():
            context.read<MainBloc>().add(UpdateEvent(token: token, flag: 2));

            showMessageSnackBar(context, state.message);
            break;
          case MarkAsReadFailure():
            showErrorSnackBar(context, state.message);
            break;
          case RevokeShareDeviceSuccess():
            onSignalUpdate(state.id);
            context
                .read<MainBloc>()
                .add(MainEventGetDevicesShared(token: token));
            showMessageSnackBar(context, state.message);
            break;
          case RevokeShareDeviceFailure():
            showErrorSnackBar(context, state.message);
            break;
          default:
        }
      },
      builder: (context, state) {
        log("Device state: $state,devices: ${devices.length}");
        devices.isEmpty ? null : deviceIds = devices.map((e) => e.id).toList();

        final List pageOptions = [
          HomePage(
            token: token,
            devices: devices,
          ),
          ScenePage(
            token: token,
            devices: devices,
          ),
          MessagePage(
            notifications: notifications,
            token: token,
          ),
          const SettingsPage()
        ];
        return Scaffold(
            backgroundColor: Colors.indigo[50],
            body: SafeArea(
              child: pageOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              index: _selectedIndex,
              onTap: (value) => setState(() => _selectedIndex = value),
              items: [
                CurvedNavigationBarItem(
                  child: const Icon(Icons.home),
                  label: 'home'.tr,
                ),
                CurvedNavigationBarItem(
                  child: const Icon(Icons.check_box_sharp),
                  label: 'scene'.tr,
                ),
                CurvedNavigationBarItem(
                  child: Badge(
                      label: Text(
                        '${notifications.length}',
                      ),
                      child: const Icon(Icons.notifications_sharp)),
                  label: 'notification'.tr,
                ),
                CurvedNavigationBarItem(
                  child: const Icon(Icons.settings),
                  label: 'settings'.tr,
                ),
              ],
              color: Colors.white,
              buttonBackgroundColor: Colors.indigoAccent,
              backgroundColor: Colors.indigo[50]!,
              animationCurve: Curves.easeInOut,
              animationDuration: const Duration(milliseconds: 600),
              letIndexChange: (value) => true,
            ));
      },
    );
  }
}
