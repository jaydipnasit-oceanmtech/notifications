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
  DateTime scheduledTimes1 = DateTime.now();
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
    // DateTime? pickedDateTime = await DatePickerBdaya.showDateTimePicker(
    //   context,
    //   showTitleActions: true,
    //   onChanged: (date) {},
    //   onConfirm: (date) {
    //     setState(() {
    //       scheduledTimes.add(date);
    //     });
    //   },
    // );
    DatePickerBdaya.showDateTimePicker(context,
        showTitleActions: true,
        onChanged: (date) => scheduledTimes1 = date,
        onConfirm: (date) {
          setState(() {
            isscheduled = false;
          });
        });

    // if (pickedDateTime != null) {
    //   setState(() {
    //     scheduledTimes.add(pickedDateTime);
    //   });
    // }
  }

  // void scheduleNotification() {
  //   for (DateTime scheduledTime in scheduledTimes) {
  //     debugPrint('Notification Scheduled for $scheduledTime');
  //     NotificationService().scheduleNotification(
  //       id: scheduledTimes.indexOf(scheduledTime), // Use index as ID for uniqueness
  //       title: 'Scheduled Notification',
  //       body: '$scheduledTime',
  //       scheduledNotificationDateTime: scheduledTime,
  //     );
  //   }
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Center(
  //         child: Text("Notifications Scheduled"),
  //       ),
  //     ),
  //   );
  // }

  int a = 0;
  void scheduleNotification() {
    setState(() {
      scheduledTimes.add(scheduledTimes1);
      isscheduled = true;
    });
    if (scheduledTimes1.isAfter(DateTime.now())) {
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
        body: '$scheduledTimes1',
        scheduledNotificationDateTime: scheduledTimes1,
      );
    } else {
      debugPrint('Scheduled time $scheduledTimes1 is not in the future');
    }

    print(a);
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
