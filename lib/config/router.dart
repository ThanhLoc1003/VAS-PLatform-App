import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vas_iot_app/module/aircon/dashboard.dart';
import 'package:vas_iot_app/module/irrigation/dashboard.dart';
import 'package:vas_iot_app/module/gate/dashboard.dart';
import 'package:vas_iot_app/module/lock/dashboard.dart';
import 'package:vas_iot_app/module/sensor/dashboard.dart';
import 'package:vas_iot_app/module/socket/dashboard.dart';
import 'package:vas_iot_app/module/switch/dashboard.dart';
import 'package:vas_iot_app/screens/account/account_screen.dart';
import 'package:vas_iot_app/screens/main/main_screen.dart';
import 'package:vas_iot_app/screens/report/report_page.dart';
import 'package:vas_iot_app/screens/setting/setting_screen.dart';

import '../features/auth/bloc/auth_bloc.dart';
import '../module/monitor/energy_page.dart';
import '../module/tracking/dashboard.dart';
import '../screens/add_device/add_device_screen.dart';
import '../screens/device-shared/shared_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/register/register_screen.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  // static const String forgotPassword = '/forgot-password';
  static const String settings = '/settings';
  static const String account = '/account';
  static const String report = '/report';
  static const String addDevice = '/add-device';
  static const String shareDevice = '/share-device';

  static const String dashboardIrrigation = '/dashboard-irrigation';
  static const String dashboardSwitch = '/dashboard-switch';
  static const String dashboardAircon = '/dashboard-aircon';
  static const String dashboardSocket = '/dashboard-socket';
  static const String dashboardLock = '/dashboard-lock';
  static const String dashboardGate = '/dashboard-gate';
  static const String dashboardSensor = '/dashboard-sensor';
  static const String dashboardTracking = '/dashboard-tracking';
  static const String dashboardEnergy = '/dashboard-energy';

  static const publicRoutes = [
    login,
    register,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) {
      return null;
    }
    return RouteName.login;
  },
  routes: [
    GoRoute(
      path: RouteName.home,
      builder: (context, state) => const MainPage(),
    ),
    GoRoute(
      path: RouteName.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RouteName.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: RouteName.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: RouteName.account,
      builder: (context, state) => const AccountPage(),
    ),
    GoRoute(
      path: RouteName.report,
      builder: (context, state) => const ReportPage(),
    ),
    GoRoute(
      path: RouteName.addDevice,
      builder: (context, state) => const AddDevicePage(),
    ),
    GoRoute(
      path: RouteName.shareDevice,
      builder: (context, state) => const SharedPage(),
    ),
    GoRoute(
      path: RouteName.dashboardIrrigation,
      builder: (context, state) => DashboardFarm(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
      path: RouteName.dashboardSwitch,
      builder: (context, state) => DashboardSwitch(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
      path: RouteName.dashboardSocket,
      builder: (context, state) => DashboardSocket(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
      path: RouteName.dashboardLock,
      builder: (context, state) => DashboardLock(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
      path: RouteName.dashboardGate,
      builder: (context, state) => DashboardGate(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
      path: RouteName.dashboardSensor,
      builder: (context, state) => DashboardSensor(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
      path: RouteName.dashboardTracking,
      builder: (context, state) => DashboardTracking(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
    GoRoute(
        path: RouteName.dashboardEnergy,
        builder: (context, state) => UsageMonitorScreen(
              index: (state.extra as Map)['index'],
            )),
    GoRoute(
      path: RouteName.dashboardAircon,
      builder: (context, state) => DashboardAircon(
          token: (state.extra as Map)['token'],
          index: (state.extra as Map)['index']),
    ),
  ],
);
