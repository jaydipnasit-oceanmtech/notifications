import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:intl/intl.dart';

import 'package:notifications/view/servies.dart';

class HomeNotifications extends StatefulWidget {
  const HomeNotifications({super.key});

  @override
  State<HomeNotifications> createState() => _HomeNotificationsState();
}

class _HomeNotificationsState extends State<HomeNotifications> {
  DateTime? scheduleTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
            child: scheduleTime != null
                ? Text(DateFormat('dd/MM/yyyy | hh:mm a').format(scheduleTime!))
                : const SizedBox.shrink()),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            DatePickerBdaya.showDateTimePicker(
              context,
              showTitleActions: true,
              onChanged: (date) => scheduleTime = date,
              onConfirm: (date) {},
            );
          },
          child: const Text("Datepick"),
        ),
        ElevatedButton(
            child: const Text('Schedule notifications'),
            onPressed: () {
              if (scheduleTime != null) {
                debugPrint('Notification Scheduled for $scheduleTime');
                NotificationService()
                    .scheduleNotification(
                  title: 'Scheduled Notification',
                  body: '$scheduleTime',
                  scheduledNotificationDateTime: scheduleTime!,
                )
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text("Done"),
                      ),
                    ),
                  );
                });
              }
            }),
        ElevatedButton(
            onPressed: () {
              NotificationService().showNotification(
                title: "Flutter Devloper",
                body: "It working",
              );
            },
            child: const Text("Instance Notification")),
        ElevatedButton(
            onPressed: () {
              NotificationService().scheduleNotificationCancel();
            },
            child: const Text("Schedule Cancel"))
      ]),
    );
  }
}
