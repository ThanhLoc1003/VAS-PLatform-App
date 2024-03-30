import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:vas_iot_app/features/platform/bloc/main_bloc.dart';

import '../../config/http_client.dart';
import '../../features/platform/data/device_api_client.dart';
import '../../features/platform/dtos/module/tracking_dto.dart';
import '../../screens/main/main_screen.dart';

late TrackingDto trackingData;

class TrackingData {
  final DateTime timeSave;
  final Data data;
  TrackingData(this.timeSave, this.data);
}

class DashboardTracking extends StatefulWidget {
  const DashboardTracking(
      {super.key, required this.token, required this.index});
  final int index;
  final String token;

  @override
  State<DashboardTracking> createState() => _DashboardTrackingState();
}

class _DashboardTrackingState extends State<DashboardTracking> {
  List<Map<String, dynamic>> data = [];
  bool isLoad = false;
  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();

    getDatas(DateTime.now());
    isLoad = true;
  }

  void getDatas(DateTime date) async {
    data.clear();
    final resBody = await DeviceApiClient(dio: dioServer)
        .getSensorDatas(devices[widget.index].id, date);
    for (var entry in resBody) {
      entry != null ? data.add(entry) : null;
    }
    setState(() {});
  }

  void _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate;
        getDatas(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TrackingData> datas = [];

    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is MainInitial) {
          getDatas(DateTime.now());
        }
      },
      builder: (context, state) {
        try {
          trackingData = TrackingDto.fromJson(devices[widget.index].toJson());
          for (var entry in data) {
            final hour = entry["_id"].split("/");
            entry['Status'].forEach((status) {
              final timeSave = status['timeSave'];
              // final hourMinute = hour + ":" + timeSave.toString().padLeft(2, '0');
              final temp = status['data']['latitude'];
              final humid = status['data']['longitude'];
              final hourMinute = DateTime(
                  int.parse(hour[3].split("-")[0]),
                  int.parse(hour[2]),
                  int.parse(hour[1]),
                  int.parse(hour[0]),
                  timeSave);
              datas.add(TrackingData(hourMinute, Data(lat: temp, long: humid)));
            });
          }
        } catch (e) {
          Navigator.pop(context);
        }
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(trackingData.name),
              actions: [
                ElevatedButton(
                    onPressed: () => _selectDate(),
                    child:
                        Text(DateFormat("dd/MM/yyyy").format(_selectedDate))),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
            body: (devices[widget.index].jsonData == {})
                ? Center(
                    child: Text("alertDeviceOff".tr,
                        style: const TextStyle(fontSize: 26),
                        textAlign: TextAlign.center))
                : FlutterMap(
                    options: MapOptions(
                      onMapEvent: (p0) {
                        // print(p0);
                      },
                      onTap: (tapPosition, point) {
                        showMenu(
                            context: context,
                            position: RelativeRect.fromLTRB(
                              tapPosition.global.dx,
                              tapPosition.global.dy,
                              MediaQuery.of(context).size.width -
                                  tapPosition.global.dx,
                              MediaQuery.of(context).size.height -
                                  tapPosition.global.dy,
                            ),
                            items: [
                              PopupMenuItem(
                                onTap: null,
                                child: Text("Latitude: ${point.latitude}"),
                              ),
                              PopupMenuItem(
                                onTap: null,
                                child: Text("Longitude: ${point.longitude}"),
                              ),
                            ]);
                      },
                      initialCenter: !isLoad
                          ? datas.isNotEmpty
                              ? LatLng(datas[datas.length - 1].data.lat,
                                  datas[datas.length - 1].data.long)
                              : LatLng(
                                  trackingData.json.lat, trackingData.json.long)
                          : LatLng(
                              trackingData.json.lat, trackingData.json.long),
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.app',
                      ),
                      PolylineLayer(polylines: [
                        Polyline(
                            points: datas
                                .map((e) => LatLng(e.data.lat, e.data.long))
                                .toList(),
                            color: Colors.blue),
                      ]),
                      MarkerLayer(
                        markers: [
                          for (TrackingData data in datas)
                            Marker(
                                point: LatLng(data.data.lat, data.data.long),
                                child: GestureDetector(
                                  onTapDown: (TapDownDetails details) {
                                    var offset = details.globalPosition;
                                    showMenu(
                                        context: context,
                                        position: RelativeRect.fromLTRB(
                                          offset.dx,
                                          offset.dy,
                                          MediaQuery.of(context).size.width -
                                              offset.dx,
                                          MediaQuery.of(context).size.height -
                                              offset.dy,
                                        ),
                                        items: [
                                          PopupMenuItem(
                                            onTap: null,
                                            child: Text(
                                                "At: ${DateFormat("hh:mm a dd/MM/yyyy").format(data.timeSave)}"),
                                          ),
                                          PopupMenuItem(
                                            onTap: null,
                                            child: Text(
                                                "Latitude: ${data.data.lat}"),
                                          ),
                                          PopupMenuItem(
                                            onTap: null,
                                            child: Text(
                                                "Longitude: ${data.data.long}"),
                                          ),
                                        ]);
                                  },
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                )),
                        ],
                      ),
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
