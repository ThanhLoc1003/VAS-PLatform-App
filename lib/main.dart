// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/features/platform/data/device_api_client.dart';
import 'package:vas_iot_app/features/platform/data/main_repository.dart';

import 'config/http_client.dart';
import 'config/router.dart';
import 'config/theme.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/data/auth_api_client.dart';
import 'features/auth/data/auth_local_data_source.dart';
import 'features/auth/data/auth_repository.dart';
import 'features/platform/data/notifi_api_client.dart';
import 'service/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // DependencyInjection.init();
  final sf = await SharedPreferences.getInstance();
  final storedLang = sf.getString('selectedLang');
  if (storedLang != null) {
    selectedLang = storedLang;
    Get.updateLocale(Locale(storedLang));
  }
  runApp(MyApp(sharedPreferences: sf));
}

bool isAuth = false;

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.sharedPreferences,
  });
  final SharedPreferences sharedPreferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(
              authApiClient: AuthApiClient(dioServer),
              authLocalDataSource: AuthLocalDataSource(sharedPreferences)),
        ),
        RepositoryProvider(
          create: (context) => MainRepository(
              deviceApiClient: DeviceApiClient(dio: dioServer),
              notifiApiClient: NotifiApiClient(dio: dioServer)),
        ),
      ],
      child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(context.read<AuthRepository>()),
            ),
            BlocProvider(
              create: (context) => MainBloc(
                deviceRepository: context.read<MainRepository>(),
              ),
            ),
          ],
          child: GetMaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: themeData,
            builder: (context, child) {
              if (!isAuth) {
                context.read<AuthBloc>().add(AuthAuthenticateStarted());
                isAuth = true;
              }

              final authState = context.watch<AuthBloc>().state;
              if (authState is AuthInitial) {
                return Container();
              } else {
                return child!;
              }
            },
            routerDelegate: router.routerDelegate,
            backButtonDispatcher: router.backButtonDispatcher,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,
            locale: LocalizationService.locale,
            fallbackLocale: LocalizationService.fallbackLocale,
            translations: LocalizationService(),
          )),
    );
  }
}
