import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../service/localization_service.dart';
import '../../ultils/theme_ext.dart';

import '../../config/router.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../pdf/pdf_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _handleLogout(BuildContext context) {
    context.read<AuthBloc>().add(AuthLogoutStarted());
  }

  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          switch (state) {
            case AuthLogoutSuccess():
              context.read<AuthBloc>().add(AuthStarted());
              context.pushReplacement(RouteName.login);
              break;
            case AuthLogoutFailure(message: final msg):
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('logoutFailed'.tr),
                    content: Text(msg),
                    backgroundColor: context.color.surface,
                  );
                },
              );
            default:
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.center,
              child: Text(
                "settings".tr,
                style: context.text.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              "general".tr,
              style: const TextStyle(fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
              height: size.height * 0.14,
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text("sharing".tr),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () => context.push(RouteName.shareDevice),
                  ),
                  ListTile(
                      title: Text("groupFavorite".tr),
                      trailing: const Icon(Icons.navigate_next_outlined),
                      onTap: null),
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "myAccount".tr,
              style: const TextStyle(fontSize: 16),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
              height: size.height * 0.14,
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text("accountSettings".tr),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () {
                      context.push(RouteName.account);
                    },
                  ),
                  ListTile(
                      title: Text("language".tr),
                      trailing: DropdownButton(
                          focusColor: Colors.amber,
                          dropdownColor: Colors.white,
                          value: selectedLang,
                          items: const [
                            DropdownMenuItem(
                                value: 'en', child: Text('English')),
                            DropdownMenuItem(
                                value: 'vi', child: Text('Vietnamese')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedLang = value!;
                            });

                            LocalizationService.changeLocale(value!);
                          }),
                      // const Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Text(
                      //       'English',
                      //       style: TextStyle(
                      //           fontSize: 16, fontWeight: FontWeight.w100),
                      //     ),
                      //     // Icon(Icons.navigate_next_outlined),
                      //     Icon(Icons.navigate_next_outlined),
                      //   ],
                      // ),
                      onTap: null),
                ],
              ),
            ),
            Text(
              "support".tr,
              style: const TextStyle(fontSize: 16),
            ),
            Container(
              padding: const EdgeInsets.all(5),
              margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
              height: size.height * 0.15,
              decoration: BoxDecoration(
                color: context.color.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: Text("userGuide".tr),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () {
                      _pdfViewerKey.currentState?.openBookmarkView();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PDFScreen(
                          pdfViewerKey: _pdfViewerKey,
                        );
                      }));
                    },
                  ),
                  ListTile(
                    title: Text("reportProblem".tr),
                    trailing: const Icon(Icons.navigate_next_outlined),
                    onTap: () => context.push(RouteName.report),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 54,
            ),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () => _handleLogout(context),
                  child: Text(
                    'logOut'.tr,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                        fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        ));
  }
}
