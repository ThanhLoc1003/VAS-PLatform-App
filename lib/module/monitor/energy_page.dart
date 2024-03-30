import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';

import '../../config/http_client.dart';
import '../../features/platform/data/device_api_client.dart';
import '../../screens/main/main_screen.dart';

class UsageMonitorScreen extends StatefulWidget {
  const UsageMonitorScreen({super.key, required this.index});
  final int index;
  @override
  State<UsageMonitorScreen> createState() => _UsageMonitorScreenState();
}

class _UsageMonitorScreenState extends State<UsageMonitorScreen> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();
  bool isLoading = true;
  List<_EnergyData> data = [];
  List<_EnergyData> dataWeek = [];
  List<_EnergyData> dataMonth = [];

  @override
  void initState() {
    super.initState();

    getDayDatas(DateTime.now());
    getWeekDatas();
    getMonthDatas();
  }

  void getDayDatas(DateTime date) async {
    data.clear();
    List<Map<String, dynamic>> temp = [];

    final datas = await DeviceApiClient(dio: dioServer)
        .getSensorDatas(devices[widget.index].id, date);

    for (var entry in datas) {
      entry != null ? temp.add(entry) : null;
    }
    for (var entry in temp) {
      final hour = entry["_id"].split("/");
      entry['Status'].forEach((status) {
        final timeSave = status['timeSave'];
        // final hourMinute = hour + ":" + timeSave.toString().padLeft(2, '0');
        final temp = status['data']['electric'].toString();
        final humid = status['data']['water'].toString();
        final hourMinute = DateTime(
            int.parse(hour[3].split("-")[0]),
            int.parse(hour[2]),
            int.parse(hour[1]),
            int.parse(hour[0]),
            timeSave);
        data.add(_EnergyData(hourMinute.toString(), temp, humid));
      });
    }
    setState(() {});
  }

  void getWeekDatas() async {
    List<Map<String, dynamic>> temp = [];
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();
    DateTime latestMonday = now.subtract(Duration(days: now.weekday - 1));

    for (var k = 5; k >= 0; k--) {
      double sumElectric = 0, sumWater = 0;
      final mondayWeek = latestMonday.subtract(Duration(days: k * 7));

      for (var i = mondayWeek;
          !i.isAfter(mondayWeek.add(const Duration(days: 6)));
          i = i.add(const Duration(days: 1))) {
        temp.clear();
        final datas = await DeviceApiClient(dio: dioServer)
            .getSensorDatas(devices[widget.index].id, i);

        for (var entry in datas) {
          entry != null ? temp.add(entry) : null;
        }

        if (temp.isNotEmpty) {
          // print(temp.length);
          final dataList = temp[temp.length - 1]['Status'];
          final electric = temp[temp.length - 1]['Status'][dataList.length - 1]
                  ['data']['electric']
              .toString();
          final water = temp[temp.length - 1]['Status'][dataList.length - 1]
                  ['data']['water']
              .toString();

          sumElectric += double.parse(electric);
          sumWater += double.parse(water);
        }
      }

      dataWeek.add(_EnergyData(
          (6 - k).toString(), sumElectric.toString(), sumWater.toString()));
    }
  }

  void getMonthDatas() async {
    List<Map<String, dynamic>> temp = [];
    // Lấy ngày hiện tại
    DateTime now = DateTime.now();
    // DateTime endOfThisMonth = DateTime(now.year, now.month + 1, 0);

    for (var k = 3; k >= 0; k--) {
      double sumElectric = 0, sumWater = 0;

      DateTime firstDayOfMonth = DateTime(now.year, now.month - k, 1);
      if (now.month - k == 0) {
        firstDayOfMonth = DateTime(now.year - 1, 12, 1);
      }
      // print(firstDayOfMonth.month);

      for (var i = firstDayOfMonth;
          now.month - k == 0
              ? !i.isAfter(DateTime(now.year - 1, 12, 31))
              : !i.isAfter(DateTime(now.year, firstDayOfMonth.month + 1, 0));
          i = i.add(const Duration(days: 1))) {
        temp.clear();
        final datas = await DeviceApiClient(dio: dioServer)
            .getSensorDatas(devices[widget.index].id, i);

        for (var entry in datas) {
          entry != null ? temp.add(entry) : null;
        }

        if (temp.isNotEmpty) {
          // print(temp.length);
          final dataList = temp[temp.length - 1]['Status'];
          final electric = temp[temp.length - 1]['Status'][dataList.length - 1]
                  ['data']['electric']
              .toString();
          final water = temp[temp.length - 1]['Status'][dataList.length - 1]
                  ['data']['water']
              .toString();

          sumElectric += double.parse(electric);
          sumWater += double.parse(water);
        }
      }

      dataMonth.add(_EnergyData(firstDayOfMonth.toString(),
          sumElectric.toString(), sumWater.toString()));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    late double percentWaterWeek,
        percentElectricWeek,
        percentWaterMonth,
        percentElectricMonth;
    if (!isLoading) {
      percentWaterWeek = ((dataWeek[dataWeek.length - 1].water! -
                  dataWeek[dataWeek.length - 2].water!) /
              dataWeek[dataWeek.length - 2].water!) *
          100;
      percentElectricWeek = ((dataWeek[dataWeek.length - 1].electric! -
                  dataWeek[dataWeek.length - 2].electric!) /
              dataWeek[dataWeek.length - 2].electric!) *
          100;
      percentWaterMonth = ((dataMonth[dataMonth.length - 1].water! -
                  dataMonth[dataMonth.length - 2].water!) /
              dataMonth[dataMonth.length - 2].water!) *
          100;
      percentElectricMonth = ((dataMonth[dataMonth.length - 1].electric! -
                  dataMonth[dataMonth.length - 2].electric!) /
              dataMonth[dataMonth.length - 2].electric!) *
          100;
    }

    return BlocBuilder<MainBloc, MainState>(
      builder: (context, state) {
        return SafeArea(
            child: Scaffold(
                backgroundColor: Colors.indigo[50],
                appBar: AppBar(
                  title: Text(devices[widget.index].name),
                ),
                body: isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 10),
                            Text("Loading..."),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(children: [
                          SizedBox(
                            height: size.height * 0.008,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: size.height * 0.22,
                                width: size.width * 0.42,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Text(
                                      "today".tr,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.electric_bolt_rounded,
                                            color: Colors.green, size: 36),
                                        Text(
                                          "${devices[widget.index].jsonData["electric"].toStringAsFixed(2)} kWh",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [
                                      const Icon(Icons.water_drop_outlined,
                                          color: Colors.blue, size: 36),
                                      Text(
                                        "${devices[widget.index].jsonData["water"].toStringAsFixed(2)} m\u00B3",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "consumption".tr,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: size.height * 0.22,
                                width: size.width * 0.435,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(24))),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Text(
                                      "thisWeek".tr,
                                      style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.electric_bolt_rounded,
                                            color: Colors.green, size: 36),
                                        Text(
                                          "${dataWeek[dataWeek.length - 1].electric?.toStringAsFixed(2)} kWh",
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(children: [
                                      const Icon(Icons.water_drop_outlined,
                                          color: Colors.blue, size: 36),
                                      Text(
                                        "${dataWeek[dataWeek.length - 1].water?.toStringAsFixed(2)} m\u00B3",
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "consumption".tr,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 15, right: 15, top: 10),
                            child: IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                            _selectedIndex == 0
                                                ? Colors.green
                                                : Colors.indigo[50]!,
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedIndex = 0;
                                          });
                                        },
                                        child: Text("day".tr)),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  _selectedIndex == 1
                                                      ? Colors.green
                                                      : Colors.indigo[50]!),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedIndex = 1;
                                          });
                                        },
                                        child: Text("week".tr)),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  _selectedIndex == 2
                                                      ? Colors.green
                                                      : Colors.indigo[50]!),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedIndex = 2;
                                          });
                                        },
                                        child: Text("month".tr)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          _selectedIndex == 0
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SfCartesianChart(

                                      // Chart title
                                      title: ChartTitle(
                                          text:
                                              '${"energyConsumption".tr} ${"of".tr} ${DateFormat("dd/MM").format(_selectedDate)}'),
                                      // Enable legend
                                      legend: const Legend(isVisible: true),
                                      // primaryXAxis: const DateTimeCategoryAxis(
                                      //   intervalType: DateTimeIntervalType.auto,
                                      // ),
                                      primaryXAxis: const DateTimeAxis(
                                        intervalType:
                                            DateTimeIntervalType.minutes,
                                      ),
                                      primaryYAxis: const NumericAxis(),
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                      zoomPanBehavior: ZoomPanBehavior(
                                        enableSelectionZooming: true,
                                        enableDoubleTapZooming: true,
                                        enablePanning: true,
                                        enableMouseWheelZooming: true,
                                        enablePinching: true,
                                        zoomMode: ZoomMode.x,
                                        selectionRectBorderColor: Colors.red,
                                        selectionRectColor:
                                            Colors.red.withOpacity(0.5),
                                      ),

                                      // Enable tooltip

                                      series: <CartesianSeries<_EnergyData,
                                          DateTime>>[
                                        LineSeries(
                                          dataSource: data,
                                          xValueMapper: (_EnergyData sales,
                                                  _) =>
                                              DateTime.parse(sales.timeSave),
                                          yValueMapper:
                                              (_EnergyData sales, _) =>
                                                  sales.electric,
                                          name: 'electric'.tr,

                                          // dataLabelSettings: const DataLabelSettings(
                                          //     isVisible: true,
                                          //     labelPosition:
                                          //         ChartDataLabelPosition.inside,
                                          //     color: Colors.amber
                                          //     ),
                                          // Enable data label
                                        ),
                                        LineSeries(
                                          dataSource: data,
                                          xValueMapper: (_EnergyData sales,
                                                  _) =>
                                              DateTime.parse(sales.timeSave),
                                          yValueMapper:
                                              (_EnergyData sales, _) =>
                                                  sales.water,
                                          name: 'water'.tr,
                                          // dataLabelSettings: const DataLabelSettings(
                                          //   isVisible: true,
                                          // ),
                                          // Enable data label
                                        ),
                                      ]),
                                )
                              : _selectedIndex == 2
                                  ? Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SfCartesianChart(

                                          // Chart title
                                          title: ChartTitle(text: 'text1'.tr),
                                          // Enable legend
                                          legend: const Legend(isVisible: true),
                                          // primaryXAxis: const DateTimeCategoryAxis(
                                          //   intervalType: DateTimeIntervalType.auto,
                                          // ),
                                          primaryXAxis: const DateTimeAxis(
                                            intervalType:
                                                DateTimeIntervalType.months,
                                          ),
                                          primaryYAxis: const NumericAxis(),
                                          tooltipBehavior:
                                              TooltipBehavior(enable: true),
                                          zoomPanBehavior: ZoomPanBehavior(
                                            enableSelectionZooming: true,
                                            enableDoubleTapZooming: true,
                                            enablePanning: true,
                                            enableMouseWheelZooming: true,
                                            enablePinching: true,
                                            zoomMode: ZoomMode.x,
                                            selectionRectBorderColor:
                                                Colors.red,
                                            selectionRectColor:
                                                Colors.red.withOpacity(0.5),
                                          ),

                                          // Enable tooltip

                                          series: <CartesianSeries<_EnergyData,
                                              DateTime>>[
                                            ColumnSeries<_EnergyData, DateTime>(
                                              dataSource: dataMonth,
                                              xValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      DateTime.parse(
                                                          sales.timeSave),
                                              yValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      sales.electric,
                                              name: 'electric'.tr,
                                              // Enable data label
                                            ),
                                            ColumnSeries<_EnergyData, DateTime>(
                                              dataSource: dataMonth,
                                              xValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      DateTime.parse(
                                                          sales.timeSave),
                                              yValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      sales.water,
                                              name: 'water'.tr,
                                              // Enable data label
                                            ),
                                          ]),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SfCartesianChart(

                                          // Chart title
                                          title: ChartTitle(text: 'text2'.tr),
                                          // Enable legend
                                          legend: const Legend(isVisible: true),
                                          // primaryXAxis: const DateTimeCategoryAxis(
                                          //   intervalType: DateTimeIntervalType.auto,
                                          // ),
                                          primaryXAxis: const CategoryAxis(),
                                          primaryYAxis: const NumericAxis(),
                                          tooltipBehavior:
                                              TooltipBehavior(enable: true),
                                          zoomPanBehavior: ZoomPanBehavior(
                                            enableSelectionZooming: true,
                                            enableDoubleTapZooming: true,
                                            enablePanning: true,
                                            enableMouseWheelZooming: true,
                                            enablePinching: true,
                                            zoomMode: ZoomMode.x,
                                            selectionRectBorderColor:
                                                Colors.red,
                                            selectionRectColor:
                                                Colors.red.withOpacity(0.5),
                                          ),

                                          // Enable tooltip

                                          series: <CartesianSeries<_EnergyData,
                                              String>>[
                                            ColumnSeries<_EnergyData, String>(
                                              dataSource: dataWeek,
                                              xValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      sales.timeSave,
                                              yValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      sales.electric,
                                              name: 'electric'.tr,
                                              // Enable data label
                                            ),
                                            ColumnSeries<_EnergyData, String>(
                                              dataSource: dataWeek,
                                              xValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      sales.timeSave,
                                              yValueMapper:
                                                  (_EnergyData sales, _) =>
                                                      sales.water,
                                              name: 'water'.tr,
                                              // Enable data label
                                            ),
                                          ]),
                                    ),
                          _selectedIndex == 0
                              ? ElevatedButton(
                                  onPressed: () => _selectDate(),
                                  child: Text(DateFormat("dd/MM/yyyy")
                                      .format(_selectedDate)))
                              : Container(),
                          if ((!isLoading))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${"thisWeek".tr}:",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.water_drop_outlined,
                                        color: Colors.blue),
                                    Image(
                                      image: AssetImage(percentWaterWeek > 0
                                          ? "assets/icons/increase.png"
                                          : "assets/icons/decrease.png"),
                                      height: 40,
                                      width: 40,
                                    ),
                                    Text(
                                      "${percentWaterWeek.toStringAsFixed(2)} %",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.electric_bolt_outlined,
                                        color: Colors.green),
                                    Image(
                                      image: AssetImage(percentElectricWeek > 0
                                          ? "assets/icons/increase.png"
                                          : "assets/icons/decrease.png"),
                                      height: 40,
                                      width: 40,
                                    ),
                                    Text(
                                      "${percentElectricWeek.toStringAsFixed(2)} %",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "${"thisMonth".tr}:",
                                style: const TextStyle(fontSize: 20),
                              ),
                              Column(
                                children: [
                                  Image(
                                    image: AssetImage(percentWaterMonth > 0
                                        ? "assets/icons/increase.png"
                                        : "assets/icons/decrease.png"),
                                    height: 40,
                                    width: 40,
                                  ),
                                  Text(
                                    "${percentWaterMonth.toStringAsFixed(2)} %",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Image(
                                    image: AssetImage(percentElectricMonth > 0
                                        ? "assets/icons/increase.png"
                                        : "assets/icons/decrease.png"),
                                    height: 40,
                                    width: 40,
                                  ),
                                  Text(
                                    "${percentElectricMonth.toStringAsFixed(2)} %",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ]),
                      )));
      },
    );
  }

  _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
        getDayDatas(_selectedDate);
      });
    }
  }
}

class _EnergyData {
  _EnergyData(this.timeSave, this.string1, this.string2) {
    electric = double.parse(string1);
    water = double.parse(string2);
  }

  final String timeSave;
  double? electric;
  double? water;
  final String string1;
  final String string2;
}
