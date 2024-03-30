import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vas_iot_app/module/irrigation/dashboard.dart';

import '../../features/platform/bloc/main_bloc.dart';

class ThresholdFarm extends StatefulWidget {
  const ThresholdFarm({super.key, required this.token});
  final String token;
  @override
  State<ThresholdFarm> createState() => _ThresholdFarmState();
}

class _ThresholdFarmState extends State<ThresholdFarm> {
  int valueTemp = 0, valueHumid = 0;
  @override
  void initState() {
    super.initState();
    valueTemp = farmData.json.node[0].threshold.temp;
    valueHumid = farmData.json.node[0].threshold.humid;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        Text("${"threshold".tr} ${"temperature".tr.toLowerCase()}"),
        Container(
          margin: const EdgeInsets.all(10),
          child: SfLinearGauge(
            minimum: 0.0,
            maximum: 100.0,
            orientation: LinearGaugeOrientation.horizontal,
            // majorTickStyle: const LinearTickStyle(length: 20),
            markerPointers: [
              LinearShapePointer(
                value: valueTemp.toDouble(),
                onChanged: (value) {
                  setState(() {
                    valueTemp = value.toInt();
                  });
                },
              ),
            ],
            animateRange: true,

            ranges: [
              LinearGaugeRange(
                startValue: 0,
                endValue: valueTemp.toDouble(),
                color: Colors.red[300],
              )
            ],
          ),
        ),
        const SizedBox(height: 60),
        Text("${"threshold".tr} ${"humidity".tr.toLowerCase()}"),
        Container(
          margin: const EdgeInsets.all(10),
          child: SfLinearGauge(
            minimum: 0.0,
            maximum: 100.0,
            orientation: LinearGaugeOrientation.horizontal,
            // majorTickStyle: const LinearTickStyle(length: 20),
            markerPointers: [
              LinearShapePointer(
                value: valueHumid.toDouble(),
                onChanged: (value) {
                  setState(() {
                    valueHumid = value.toInt();
                  });
                },
              ),
            ],
            animateRange: true,

            ranges: [
              LinearGaugeRange(
                startValue: 0,
                endValue: valueHumid.toDouble(),
                color: Colors.blue[300],
              )
            ],
          ),
        ),
        const SizedBox(height: 60),
        ElevatedButton(
          onPressed: () {
            farmData.json.node[0].threshold.temp = valueTemp.toInt();
            farmData.json.node[0].threshold.humid = valueHumid.toInt();

            context.read<MainBloc>().add(MainEventUpdateDevice(
                token: widget.token, id: farmData.id, data: farmData.toJson()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
          ),
          child: Text("save".tr,
              style: const TextStyle(color: Colors.white, fontSize: 20)),
        )
      ],
    );
  }
}
