// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NetworkController extends GetxController {
//   final Connectivity _connectivity = Connectivity();

//   @override
//   void onInit() {
//     super.onInit();
//     print("lang nghe su kien ket noi");
    

//     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
//   }


//   void _updateConnectionStatus(ConnectivityResult connectivityResult) {
//     if (connectivityResult == ConnectivityResult.none) {
//       print("Khong ket noi Internet");
//       // Get.rawSnackbar(
//       //     messageText: const Text('PLEASE CONNECT TO THE INTERNET',
//       //         style: TextStyle(color: Colors.white, fontSize: 14)),
//       //     isDismissible: false,
//       //     duration: const Duration(days: 1),
//       //     backgroundColor: Colors.red[400]!,
//       //     icon: const Icon(
//       //       Icons.wifi_off,
//       //       color: Colors.white,
//       //       size: 35,
//       //     ),
//       //     margin: EdgeInsets.zero,
//       //     snackStyle: SnackStyle.GROUNDED);
//     } else {
//       print("Co ket noi Internet");
//       // if (Get.isSnackbarOpen) {
//       //   Get.closeCurrentSnackbar();
//       // }
//     }
//   }
// }

// class DependencyInjection {
//   static void init() {
//     Get.put<NetworkController>(NetworkController(), permanent: true);
//   }
// }
