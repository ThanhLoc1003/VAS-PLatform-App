import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dashboard.dart';

class MoreSensor extends StatelessWidget {
  const MoreSensor({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text(
            "ID device: ${sensorData.id}",
            style: const TextStyle(fontSize: 20.0),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: sensorData.id)),
          ),
        ),
        ListTile(
          title: Text(
            "Type of device: ${sensorData.type}",
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
