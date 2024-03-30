import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vas_iot_app/module/irrigation/dashboard.dart';

import '../../config/http_client.dart';
import '../../features/platform/data/device_api_client.dart';

class TemperatureData {
  final DateTime timeSave;
  late double temp;
  final String temperature;

  TemperatureData(this.timeSave, this.temperature) {
    temp = double.parse(temperature);
  }
}

class HumidityData {
  final DateTime timeSave;
  late double humid;
  final String humidity;

  HumidityData(this.timeSave, this.humidity) {
    humid = double.parse(humidity);
  }
}

class AnalyticPage extends StatefulWidget {
  const AnalyticPage({super.key});

  @override
  AnalyticPageState createState() => AnalyticPageState();
}

class AnalyticPageState extends State<AnalyticPage> {
  DateTime selectedDate = DateTime.now();
  List<Map<String, dynamic>> data = [];
  @override
  void initState() {
    super.initState();
    getDatas(DateTime.now());
  }

  void getDatas(DateTime date) async {
    data.clear();
    final datas = await DeviceApiClient(dio: dioServer)
        .getSensorDatas(farmData.json.node[0].id, date);
    setState(() {
      for (var entry in datas) {
        entry != null ? data.add(entry) : null;
      }
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<TemperatureData> temperatureData = [];
    List<HumidityData> humidityData = [];

    // Extracting temperature and humidity data from the provided data
    for (var entry in data) {
      final hour = entry["_id"].split("/");
      entry['Status'].forEach((status) {
        final timeSave = status['timeSave'];
        // final hourMinute = hour + ":" + timeSave.toString().padLeft(2, '0');
        final temp = status['data']['temp'].toString();
        final humid = status['data']['humid'].toString();
        final hourMinute = DateTime(
            int.parse(hour[3].split("-")[0]),
            int.parse(hour[2]),
            int.parse(hour[1]),
            int.parse(hour[0]),
            timeSave);
        temperatureData.add(TemperatureData(hourMinute, temp));
        humidityData.add(HumidityData(hourMinute, humid));
      });
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SfCartesianChart(
            title: ChartTitle(text: 'temperature'.tr),
            primaryXAxis: const DateTimeAxis(
              intervalType: DateTimeIntervalType.minutes,
            ),
            primaryYAxis:
                NumericAxis(title: AxisTitle(text: '${"temperature".tr} (°C)')),
            tooltipBehavior: TooltipBehavior(enable: true),
            zoomPanBehavior: ZoomPanBehavior(
              enableSelectionZooming: true,
              enableDoubleTapZooming: true,
              enablePanning: true,
              enableMouseWheelZooming: true,
              enablePinching: true,
              selectionRectBorderColor: Colors.red,
              selectionRectColor: Colors.red.withOpacity(0.5),
            ),
            series: <CartesianSeries<dynamic, DateTime>>[
              LineSeries<TemperatureData, DateTime>(
                dataSource: temperatureData,
                color: Colors.red,
                xValueMapper: (TemperatureData temp, _) => temp.timeSave,
                yValueMapper: (TemperatureData temp, _) => temp.temp,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: SfCartesianChart(
            title: ChartTitle(text: 'humidity'.tr),
            primaryXAxis: const DateTimeAxis(
              intervalType: DateTimeIntervalType.minutes,
            ),
            primaryYAxis:
                NumericAxis(title: AxisTitle(text: '${"humidity".tr} (%)')),
            zoomPanBehavior: ZoomPanBehavior(
              enableSelectionZooming: true,
              enableDoubleTapZooming: true,
              enablePanning: true,
              enableMouseWheelZooming: true,
              enablePinching: true,
              selectionRectBorderColor: Colors.red,
              selectionRectColor: Colors.red.withOpacity(0.5),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries<dynamic, DateTime>>[
              LineSeries<HumidityData, DateTime>(
                dataSource: humidityData,
                color: Colors.blue,
                xValueMapper: (HumidityData temp, _) => temp.timeSave,
                yValueMapper: (HumidityData temp, _) => temp.humid,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Form(
          key: _formKey,
          child: TextFormField(
            controller: TextEditingController(
                text: DateFormat('dd/MM/yyyy').format(selectedDate)),
            keyboardType: TextInputType.datetime,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
              labelStyle: const TextStyle(),
              floatingLabelAlignment: FloatingLabelAlignment.center,
              labelText: 'date'.tr,
              border: const UnderlineInputBorder(),
              hintText: 'dd/MM/yyyy',
              prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate =
                          selectedDate.subtract(const Duration(days: 1));
                    });
                    getDatas(selectedDate);
                  },
                  icon: const Icon(Icons.arrow_back_ios_outlined)),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedDate = selectedDate.add(const Duration(days: 1));
                      if (selectedDate.isAfter(DateTime.now())) {
                        selectedDate = DateTime.now();
                      }
                    });
                    getDatas(selectedDate);
                  },
                  icon: const Icon(Icons.navigate_next_outlined)),
              icon: const Icon(Icons.calendar_today),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a date';
              }
              final dateString = value.split("/");
              final date = DateTime.tryParse(
                  "${dateString[2]}-${dateString[1].padLeft(2, '0')}-${dateString[0].padLeft(2, '0')}");

              if (date == null) {
                return 'Invalid date';
              }
              if (date.isAfter(DateTime.now())) {
                return 'Date cannot be in the future';
              }
              if (date.isBefore(
                  DateTime.now().subtract(const Duration(days: 365)))) {
                return 'Date cannot be more than 1 year ago';
              }

              return null;
            },
            onFieldSubmitted: (value) async {
              if (_formKey.currentState!.validate()) {
                final dateString = value.split("/");
                setState(() {
                  selectedDate = DateTime.parse(
                      "${dateString[2]}-${dateString[1].padLeft(2, '0')}-${dateString[0].padLeft(2, '0')}");
                  getDatas(selectedDate);
                });
              }
            },
          ),
        ),
      ],
    );
  }
}
