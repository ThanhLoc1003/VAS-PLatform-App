import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_iot_app/features/auth/bloc/auth_bloc.dart';
import '/../ultils/theme_ext.dart';

import '../../features/auth/data/auth_local_data_source.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late AuthLocalDataSource _authLocalDataSource;
  late String email = '';
  late String userid = '';

  @override
  void initState() {
    super.initState();

    _getToken();
  }

  Future<void> _getToken() async {
    final sf = await SharedPreferences.getInstance();
    _authLocalDataSource = AuthLocalDataSource(sf);
    final token = await _authLocalDataSource.getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    setState(() {
      email = decodedToken['email'];
      userid = decodedToken['userId'];
    });
  }

  void showMessageSnackBar(BuildContext context, String message, bool flag) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(20),
      shape: const StadiumBorder(),
      backgroundColor: flag ? Colors.greenAccent.shade400 : Colors.red,
      duration: const Duration(seconds: 4),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthChangeSuccess) {
          showMessageSnackBar(context, state.message, true);
        }
        if (state is AuthChangeFailure) {
          showMessageSnackBar(context, state.message, false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.indigo[50],
        body: SafeArea(
            child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                Text(
                  "accountSettings".tr,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
              height: size.height * 0.26,
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    title: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0, // Độ dày của kẻ gạch
                          ),
                        ),
                      ),
                      child: Text(
                        email,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    "Device access token",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  ListTile(
                    title: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0, // Độ dày của kẻ gạch
                          ),
                        ),
                      ),
                      child: Text(
                        userid,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Text("Connect your device with access token",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      )),
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                height: size.height * 0.08,
                decoration: BoxDecoration(
                  color: context.color.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: ListTile(
                  title: Text("changePassword".tr,
                      style: const TextStyle(
                        fontSize: 18.0,
                      )),
                  trailing: const Icon(Icons.navigate_next),
                  onTap: () => _showChangePasswordDialog(),
                ))
          ],
        )),
      ),
    );
  }

  _showChangePasswordDialog() {
    final formKey = GlobalKey<FormState>();
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final newPasswordConfirmController = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              title: Text("changePassword".tr),
              content: AutofillGroup(
                  child: Form(
                      key: formKey,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        TextFormField(
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          controller: oldPasswordController,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: 'oldPassword'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'fieldNull'.tr;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          controller: newPasswordController,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: 'newPassword'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'fieldNull'.tr;
                            }
                            if (value != newPasswordConfirmController.text) {
                              return 'matchPassword'.tr;
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          controller: newPasswordConfirmController,
                          autofillHints: const [AutofillHints.email],
                          decoration: InputDecoration(
                            labelText: 'confirmPassword'.tr,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'fieldNull'.tr;
                            }
                            if (value != newPasswordController.text) {
                              return 'mathchPassword'.tr;
                            }
                            return null;
                          },
                        ),
                      ]))),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'cancel'.tr,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.pop(context);
                        context.read<AuthBloc>().add(AuthChangePasswordStarted(
                              userId: userid,
                              oldPassword: oldPasswordController.text,
                              newPassword: newPasswordController.text,
                            ));
                      }
                    },
                    child: Text(
                      'confirm'.tr,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    )),
              ]);
        });
  }
}
