import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';

import 'package:notifications/view/servies.dart';

class HomeNotifications extends StatefulWidget {
  const HomeNotifications({super.key});

  @override
  State<HomeNotifications> createState() => _HomeNotificationsState();
}

DateTime scheduleTime = DateTime.now();

class _HomeNotificationsState extends State<HomeNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(child: Text("$scheduleTime")),
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
        const SizedBox(height: 10),
        ElevatedButton(
          child: const Text('Schedule notifications'),
          onPressed: () {
            debugPrint('Notification Scheduled for $scheduleTime');
            NotificationService()
                .scheduleNotification(
                  title: 'Scheduled Notification',
                  body: '$scheduleTime',
                  scheduledNotificationDateTime: scheduleTime,
                )
                .then(
                  (value) => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(
                        child: Text("Done"),
                      ),
                    ),
                  ),
                );
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              NotificationService().showNotification(
                title: "Flutter Devloper",
                body: "It working",
              );
            },
            child: const Text("Instance Notification"))
      ]),
    );
  }
}
