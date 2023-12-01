import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_bdaya/flutter_datetime_picker_bdaya.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
            child: scheduleTime != null
                ? Text(DateFormat('dd/MM/yyyy | hh:mm a').format(scheduleTime!))
                : const SizedBox.shrink()),
        const SizedBox(height: 10),
        commonButton(
          icon: Icons.date_range,
          onPressed: () {
            DatePickerBdaya.showDateTimePicker(
              context,
              showTitleActions: true,
              onChanged: (date) => scheduleTime = date,
              onConfirm: (date) {},
            );
          },
          text: "Datepick",
        ),
        commonButton(
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
            },
            icon: Icons.schedule_send,
            text: "Schedule notifications"),
        commonButton(
          onPressed: () {
            NotificationService().showNotification(
              title: "Flutter Devloper",
              body: "It working",
            );
          },
          icon: Icons.notifications,
          text: "Instance Notification",
        ),
        commonButton(
          onPressed: () => NotificationService().scheduleNotificationCancel(),
          icon: Icons.cancel,
          text: "Schedule Cancel",
        ),
      ]),
    );
  }
}

Widget commonButton({required VoidCallback onPressed, required IconData icon, required String text}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 50.w),
    child: ElevatedButton(
      onPressed: onPressed,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon),
        SizedBox(width: 10.w),
        Text(text),
      ]),
    ),
  );
}
