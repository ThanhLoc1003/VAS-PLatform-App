import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import 'package:vas_iot_app/screens/main/main_screen.dart';
import 'package:vas_iot_app/ultils/theme_ext.dart';

import 'package:vas_iot_app/widgets/single_child_scroll_view_with_column.dart';
import 'package:weather/weather.dart';

import '../../config/router.dart';
import '../../features/platform/dtos/device_dto.dart';
import '../../service/localization_service.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  HomePage({super.key, required this.devices, required this.token});
  List<DeviceDto> devices = [];
  String token = '';

  @override
  Widget build(BuildContext context) {
    // print("1,devices: ${devices.length}");
    return SingleChildScrollViewWithColumn(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _AppBar(
            devices: devices,
            token: token,
          ),
          const SizedBox(height: 20),
          if (devices.isEmpty)
            Align(
                alignment: Alignment.center,
                heightFactor: 25,
                child: Text(
                  "letAddDevice".tr,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ))
          else
            for (int i = 0; i < devices.length; i++)
              Container(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(Icons.star_outline_sharp),
                  subtitle: devices[i].online
                      ? Text(
                          "${"device".tr} ${"is".tr} ${"online".tr.toLowerCase()}",
                          style:
                              TextStyle(color: Colors.green[900], fontSize: 16))
                      : Text(
                          "${"device".tr} ${"is".tr} ${"offline".tr.toLowerCase()}",
                          style:
                              const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text(
                    devices[i].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  onTap: () {
                    chooseModule(context, i, token);
                  },
                  trailing: PopupMenuButton(itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          onTap: () {
                            showCustomNameDialog(context, i);
                          },
                          child: TextButton.icon(
                            autofocus: true,
                            // style: ButtonStyle(
                            //     backgroundColor:
                            //         MaterialStateProperty.all(Colors.white)),
                            onPressed: () {
                              showCustomNameDialog(context, i);
                            },

                            icon: const Icon(Icons.mode_edit_rounded),
                            label: Text("edit".tr),
                          )),
                      PopupMenuItem(
                          onTap: () {
                            showCustomShareDialog(context, i);
                          },
                          child: TextButton.icon(
                            autofocus: true,
                            // style: ButtonStyle(
                            //     backgroundColor:
                            //         MaterialStateProperty.all(Colors.white)),
                            onPressed: () => showCustomShareDialog(context, i),
                            icon: const Icon(Icons.share),
                            label: Text("share".tr),
                          )),
                      PopupMenuItem(
                          onTap: () {
                            context.read<MainBloc>().add(MainEventDeleteDevice(
                                token: token, id: devices[i].id));
                          },
                          child: TextButton.icon(
                            onPressed: () {
                              context.read<MainBloc>().add(
                                  MainEventDeleteDevice(
                                      token: token, id: devices[i].id));
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.delete_forever_outlined),
                            label: Text("delete".tr),
                          )),
                    ];
                  }),
                ),
              )
        ],
      ),
    );
  }

  void showCustomShareDialog(BuildContext context, int index) {
    emailController.clear();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text("${"input".tr} email ${"user".tr.toLowerCase()}"),
              content: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "${"enter".tr} email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'fieldNull'.tr;
                        }

                        return null;
                      }),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context.read<MainBloc>().add(MainEventShareDevice(
                          token: token,
                          id: devices[index].id,
                          email: emailController.text));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "submit".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceBetween,
            ));
  }

  void showCustomNameDialog(BuildContext context, int index) {
    nameController.clear();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                  "${"edit".tr} ${"name".tr.toLowerCase()} ${"device".tr.toLowerCase()} "),
              content: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: "${"enter".tr} ${"name".tr.toLowerCase()}",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'fieldNull'.tr;
                        }

                        return null;
                      }),
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      context.read<MainBloc>().add(MainEventUpdateNameDevice(
                            token: token,
                            id: devices[index].id,
                            name: nameController.text,
                          ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    "submit".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
              ],
              actionsAlignment: MainAxisAlignment.spaceBetween,
            ));
  }
}

void chooseModule(BuildContext context, int index, String token) {
  switch (devices[index].type) {
    case "Tracking":
      context.push(RouteName.dashboardTracking, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Irrigation":
      context.push(RouteName.dashboardIrrigation, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Aircon":
      context.push(RouteName.dashboardAircon, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Switch":
      context.push(RouteName.dashboardSwitch, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Socket":
      context.push(RouteName.dashboardSocket, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Lock":
      context.push(RouteName.dashboardLock, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Gate":
      context.push(RouteName.dashboardGate, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Sensor":
      context.push(RouteName.dashboardSensor, extra: {
        "token": token,
        "index": index,
      });
      break;
    case "Energy":
      context.push(RouteName.dashboardEnergy, extra: {
        "token": token,
        "index": index,
      });
      break;
    default:
      break;
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({required this.devices, required this.token});
  final List<DeviceDto> devices;
  final String token;

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  bool isSearching = false;
  double lat = 10.7952219, lng = 106.7217912;

  @override
  void initState() {
    super.initState();
    if (isLoadedWeather == false) {
      _determinePosition();
    }
  }

  final SuggestionsController _controller = SuggestionsController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        const AddDeviceWidget(),
        _buildSuggestions(context),
        const SizedBox(height: 20),
        _buildWeatherWidget(context, size),
      ],
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: TypeAheadField(
        decorationBuilder: (context, child) {
          return Material(
            type: MaterialType.card,
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: child,
          );
        },
        offset: const Offset(0, 10),
        constraints: const BoxConstraints(maxHeight: 500),
        builder: (context, controller, focusNode) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: '${"search".tr} ${"device".tr.toLowerCase()}...',
              suffixIcon: IconButton(
                  onPressed: () {
                    if (isSearching) {
                      _controller.close();
                      controller.clear();
                    }
                  },
                  icon: Icon(isSearching ? Icons.arrow_back_ios : null)),
            ),
            onTap: () {
              setState(() {
                isSearching = true;
              });
              // Handle when the search icon is pressed.
            },
          );
        },
        suggestionsController: _controller,
        suggestionsCallback: (pattern) {
          return widget.devices
              .where((country) =>
                  country.name.toLowerCase().contains(pattern.toLowerCase()))
              .toList();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.name),
          );
        },
        onSelected: (value) {
          setState(() {
            isSearching = false;
          });
          // Handle when a suggestion is selected.

          chooseModule(context, devices.indexOf(value), widget.token);
          _controller.close();
        },
      ),
    );
  }

  Widget _buildWeatherWidget(BuildContext context, Size size) {
    return isLoadedWeather
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            width: size.width,
            height: size.height * 0.25,
            child: Card(
                color: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.only(top: 15, left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                '${dataWeather.areaName}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black45,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'flutterfonts',
                                    ),
                              ),
                            ),
                            Center(
                              child: Text(
                                DateFormat()
                                    .add_MMMMEEEEd()
                                    .format(DateTime.now()),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.black45,
                                      fontSize: 16,
                                      fontFamily: 'flutterfonts',
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 20),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "${dataWeather.weatherDescription}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.black45,
                                        fontSize: 22,
                                        fontFamily: 'flutterfonts',
                                      ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${dataWeather.tempFeelsLike.toString().split(" ")[0]} \u2103',
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          color: Colors.black45,
                                          fontFamily: 'flutterfonts'),
                                ),
                                Text(
                                  'min: ${dataWeather.tempMin.toString().split(" ")[0]} \u2103 / max: ${dataWeather.tempMax.toString().split(" ")[0]} \u2103',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'flutterfonts',
                                      ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                          'assets/weather/${dataWeather.weatherIcon}.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${dataWeather.windSpeed} m/s',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Colors.black45,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'flutterfonts',
                                      ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ])),
          )
        : const CircularProgressIndicator.adaptive();
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    bool isPermision = true;
    final WeatherFactory ws = WeatherFactory("93ce9559bf88b7fe788170e4a12f1931",
        language:
            selectedLang == 'en' ? Language.ENGLISH : Language.VIETNAMESE);

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isPermision = false;

      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isPermision = false;
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isPermision = false;
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    if (isPermision) {
      final result = await Geolocator.getCurrentPosition();
      lat = result.latitude;
      lng = result.longitude;
    }
    Weather weather = await ws.currentWeatherByLocation(lat, lng);

    setState(() {
      dataWeather = weather;

      isLoadedWeather = true;
    });
  }
}

class AddDeviceWidget extends StatelessWidget {
  const AddDeviceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "devices".tr,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            tooltip: "${"add".tr} ${"device".tr}",
            onPressed: () => context.push(RouteName.addDevice),
            icon: const Icon(
              Icons.add,
              size: 26,
              color: Colors.black,
            )),
      ],
    );
  }
}
