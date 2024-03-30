import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';
import '../../config/router.dart';
import '../../features/auth/data/auth_local_data_source.dart';
import '/../ultils/theme_ext.dart';
import '/../widgets/single_child_scroll_view_with_column.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({super.key});

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  String token = '';
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();

  void getToken() async {
    final sf = await SharedPreferences.getInstance();
    var authLocalDataSource = AuthLocalDataSource(sf);
    token = (await authLocalDataSource.getToken())!;
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  void showCustomDialog(String type) {
    nameController.clear();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                  "${"input".tr} ${"name".tr.toLowerCase()} ${"device".tr.toLowerCase()} "),
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
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "cancel".tr,
                    style: context.text.bodyLarge!
                        .copyWith(color: Colors.black, fontSize: 24),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<MainBloc>().add(MainEventAddDevice(
                          name: nameController.text, token: token, type: type));
                      context.go(RouteName.home);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[50],
      appBar: AppBar(),
      body: SafeArea(
          child: SingleChildScrollViewWithColumn(
              child: Column(
        children: [
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/sensor.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "sensor".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Sensor"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/irrigation.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "irrigation".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Irrigation"),
          ),
          const SizedBox(height: 20),
          ListTile(
              leading: const Image(
                image: AssetImage("assets/icons/switch.png"),
                height: 40,
                width: 40,
              ),
              title: Text(
                "switch".tr,
                style: context.text.bodyLarge!
                    .copyWith(color: Colors.black, fontSize: 24),
              ),
              onTap: () => showCustomDialog("Switch")),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/lock.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "lock".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Lock"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/map.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "tracking".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Tracking"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/energy.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "energy".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Energy"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/gate.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "gate".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Gate"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/socket.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "socket".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Socket"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/air.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "aircon".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Aircon"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/valve.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "vavle".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
            onTap: () => showCustomDialog("Vavle"),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Image(
              image: AssetImage("assets/icons/more.png"),
              height: 40,
              width: 40,
            ),
            title: Text(
              "other".tr,
              style: context.text.bodyLarge!
                  .copyWith(color: Colors.black, fontSize: 24),
            ),
          ),
        ],
      ))),
    );
  }
}
