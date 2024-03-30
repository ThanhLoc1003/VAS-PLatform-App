import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_iot_app/ultils/theme_ext.dart';

import '../../features/auth/data/auth_local_data_source.dart';
import '../../features/platform/bloc/main_bloc.dart';

class ShareDevice {
  final String id;
  final String email;
  final String name;

  ShareDevice({required this.id, required this.email, required this.name});

  factory ShareDevice.fromJson(Map<String, dynamic> json) {
    return ShareDevice(
      id: json['_id'].toString(),
      email: json['email'],
      name: json['name'],
    );
  }
}

List<ShareDevice> sharedDevices = [];

class SharedPage extends StatefulWidget {
  const SharedPage({super.key});

  @override
  State<SharedPage> createState() => _SharedPageState();
}

class _SharedPageState extends State<SharedPage> {
  String token = '';
  // List<DeviceDto> devices = [];

  void getToken() async {
    final sf = await SharedPreferences.getInstance();
    var authLocalDataSource = AuthLocalDataSource(sf);
    token = (await authLocalDataSource.getToken())!;
    // ignore: use_build_context_synchronously
    context.read<MainBloc>().add(MainEventGetDevicesShared(token: token));
  }

  @override
  void initState() {
    getToken();

    super.initState();
  }

  void showCustomDialog(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title:  Text('removeSharedDevice'.tr),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<MainBloc>().add(MainEventRevokeShareDevice(
                        token: token,
                        id: sharedDevices[index].id,
                        email: sharedDevices[index].email));
                    // context.read<MainBloc>().add(MainEventAddDevice(
                    //     name: nameController.text, token: token, type: type));
                    // context.go(RouteName.home);
                  },
                  child: Text(
                    "confirm".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
                // ElevatedButton(onPressed: onPressed, child: child)
              ],
              actionsAlignment: MainAxisAlignment.spaceBetween,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return Scaffold(
            backgroundColor: Colors.indigo[50],
            appBar: AppBar(
              title:  Text("listSharedDevices".tr),
            ),
            body: sharedDevices.isEmpty
                ?  Center(
                    child: Text("noData".tr),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 30),
                    itemBuilder: (context, index) => Container(
                          padding: const EdgeInsets.all(10),
                          child: ListTile(
                            title: Text(sharedDevices[index].name),
                            subtitle: Text(
                                "${"sharedWith".tr} ${sharedDevices[index].email}"),
                            trailing: const Icon(Icons.delete_forever),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onTap: () => showCustomDialog(index),
                          ),
                        ),
                    itemCount: sharedDevices.length));
      },
    );
  }
}
// void getSharedDevices() async {
  //   if (token.isNotEmpty) {
  //     sharedDevices.clear();
  //     final devices =
  //         await DeviceApiClient(dio: dioServer).getDevicesShared(token);
  //     for (int i = 0; i < devices.length; i++) {
  //       for (int j = 0; j < devices[i].sharedWith.length; j++) {
  //         sharedDevices.add(ShareDevice(
  //             id: devices[i].id,
  //             email: devices[i].sharedWith[j],
  //             name: devices[i].name));
  //       }
  //     }

  //     // print("${devices.length} device, ");
  //     setState(() {});
  //   }
  // }