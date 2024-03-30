import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/platform/bloc/main_bloc.dart';
import '../../features/platform/dtos/notification_dto.dart';

class MessagePage extends StatefulWidget {
  const MessagePage(
      {super.key, required this.notifications, required this.token});
  final List<NotificationDto> notifications;
  final String token;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  void markAsRead(String id) async {
    context
        .read<MainBloc>()
        .add(MainEventMarkAsRead(token: widget.token, id: id)); // add event
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.notifications[0].id);
    return widget.notifications.isEmpty
        ? Center(
            child: Text(
              "noData".tr,
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: GoogleFonts.nunito().fontFamily),
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.only(
              top: 50,
              left: 20,
              right: 20,
            ),
            itemCount: widget.notifications.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"content".tr}: ",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: widget.notifications[index].message,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black))
                  ])),
                  // Text(
                  //     "${"content".tr}: ${widget.notifications[index].message}"),
                  subtitle: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "${"from".tr}: ",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    TextSpan(
                        text: widget.notifications[index].sender,
                        style:
                            const TextStyle(fontSize: 15, color: Colors.black))
                  ])),
                  trailing: const Icon(Icons.chevron_right),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () => markAsRead(widget.notifications[index].id),
                ),
              );
            });
  }
}
