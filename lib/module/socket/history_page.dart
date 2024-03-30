import 'package:flutter/material.dart';
import 'package:vas_iot_app/features/platform/data/history_api_client.dart';

import '../../config/http_client.dart';
import 'dashboard.dart';
import 'package:intl/intl.dart';

class HistorySocket extends StatefulWidget {
  const HistorySocket({super.key});

  @override
  State<HistorySocket> createState() => _HistorySocketState();
}

class _HistorySocketState extends State<HistorySocket> {
  var histories = [];
  @override
  void initState() {
    getHistories();
    super.initState();
  }

  void getHistories() async {
    final datas =
        await HistoryApiClient(dio: dioServer).getHistories(socketData.id);
    setState(() {
      histories = datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return histories.isEmpty
        ? const Center(
            child: Text("No history"),
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
                    "At: ${DateFormat('dd/MM/yyyy hh:mm a').format(histories[index].timestamp)}"),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          );
  }
}
