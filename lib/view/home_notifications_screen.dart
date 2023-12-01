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
  List<DateTime> scheduledTimes = [];
  DateTime selectScheduledTimes = DateTime.now();
  bool isscheduled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        if (scheduledTimes.isNotEmpty) ...[
          for (DateTime scheduledTime in scheduledTimes)
            Text(
              DateFormat('dd/MM/yyyy | hh:mm a').format(scheduledTime),
            ),
        ],
        const SizedBox(height: 10),
        commonButton(
          icon: Icons.date_range,
          onPressed: () {
            selectDateTime(context);
          },
          text: "Datepick",
        ),
        commonButton(
            onPressed: () {
              isscheduled == false ? scheduleNotification() : null;
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
          onPressed: () {
            clearScheduledTimes();
            NotificationService().scheduleNotificationCancelAll();
          },
          icon: Icons.cancel,
          text: "Schedule Cancel",
        ),
        commonButton(
            onPressed: () => NotificationService().checkActiveNotifications(),
            icon: Icons.get_app_rounded,
            text: "GetNotifications")
      ]),
    );
  }

  Future<void> selectDateTime(BuildContext context) async {
    DatePickerBdaya.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (date) => selectScheduledTimes = date,
        onConfirm: (date) {
          setState(() {
            isscheduled = false;
          });
        });
  }

  void scheduleNotification() {
    setState(() {
      scheduledTimes.add(selectScheduledTimes);
      isscheduled = true;
    });
    if (selectScheduledTimes.isAfter(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text(
              'Scheduled Notification',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ),
      );
      NotificationService().scheduleNotification(
        title: 'Scheduled Notification',
        body: '$selectScheduledTimes',
        scheduledNotificationDateTime: selectScheduledTimes,
      );
    } else {
      debugPrint('Scheduled time $selectScheduledTimes is not in the future');
    }
  }

  void clearScheduledTimes() {
    setState(() {
      scheduledTimes.clear();
    });
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
