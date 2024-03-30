import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dashboard.dart';

class MoreAircon extends StatelessWidget {
  const MoreAircon({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            "ID device: ${airconData.id}",
            style: const TextStyle(fontSize: 20.0),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () =>
                Clipboard.setData(ClipboardData(text: airconData.id)),
          ),
        ),
        ListTile(
          title: Text(
            "Type of device: ${airconData.type}",
            style: const TextStyle(fontSize: 20),
          ),
        ),
        RichText(
            text: const TextSpan(
                text: "HTTP Api:\n",
                style: TextStyle(fontSize: 26, color: Colors.black),
                children: [
              TextSpan(
                text:
                    "\t\t\tGet:\n +) http://\$DOMAIN_SERVER:\$PORT/api/devices/get/\$id\n"
                    "+) Example: \n\t\t\t\t\t\t{\"data\":\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t{\"button1\": true,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\"button2\": true}\n\t\t\t\t\t\t\t}\n",
                style: TextStyle(fontSize: 20),
              ),
              TextSpan(
                text:
                    "\t\t\tPut:\n +) http://\$DOMAIN_SERVER:\$PORT/api/devices/update-hw/\$id\n"
                    "+) Body: \n\t\t\t\t\t\t{\"data\":\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t{\"button1\": true,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\"button2\": true}\n\t\t\t\t\t\t\t}\n",
                style: TextStyle(fontSize: 20),
              ),
            ])),
        RichText(
            text: const TextSpan(
                text: "MQTT Api:\n",
                style: TextStyle(fontSize: 26, color: Colors.black),
                children: [
              TextSpan(
                text: "\t\t\tSubcribe:\n +) mqtt://\$DOMAIN_SERVER:\$PORT\n"
                    "+) Topic: device/\$id\n"
                    "+) Example: \n\t\t\t\t\t\t{\"data\":\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t{\"button1\": true,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\"button2\": true}\n\t\t\t\t\t\t\t}\n",
                style: TextStyle(fontSize: 20),
              ),
              TextSpan(
                text: "\t\t\tPublish:\n +) mqtt://\$DOMAIN_SERVER:\$PORT\n"
                    "+) Topic: Update\n"
                    "+) Message: \n\t\t\t\t\t\t{\"data\":\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t{\"button1\": true,\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\"button2\": true}\n\t\t\t\t\t\t\t}\n",
                style: TextStyle(fontSize: 20),
              ),
            ]))
      ],
    );
  }
}
