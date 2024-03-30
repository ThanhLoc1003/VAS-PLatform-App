import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';

class MoreFarm extends StatelessWidget {
  const MoreFarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            "ID device: ${farmData.id}",
            style: const TextStyle(fontSize: 20.0),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: farmData.id)),
          ),
        ),
        ListTile(
          title: Text(
            "Type of device: ${farmData.type}",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
