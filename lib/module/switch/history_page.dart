import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:vas_iot_app/features/platform/data/history_api_client.dart';

import '../../config/http_client.dart';
import 'dashboard.dart';
import 'package:intl/intl.dart';

class HistorySwitch extends StatefulWidget {
  const HistorySwitch({super.key});

  @override
  State<HistorySwitch> createState() => _HistorySwitchState();
}

class _HistorySwitchState extends State<HistorySwitch> {
  var histories = [];
  @override
  void initState() {
    getHistories();
    super.initState();
  }

  void getHistories() async {
    final datas =
        await HistoryApiClient(dio: dioServer).getHistories(switchData.id);
    setState(() {
      histories = datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return histories.isEmpty
        ? Center(
            child: Text("noData".tr),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(top: 30),
            itemCount: histories.length,
            itemBuilder: (context, index) => Container(
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(
                  histories[index].details,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                    "${"at".tr}: ${DateFormat('dd/MM/yyyy hh:mm a').format(histories[index].timestamp)}"),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
  }
}
