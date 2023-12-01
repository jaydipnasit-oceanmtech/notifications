import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  List<PendingNotificationRequest> pendingNotification = [];
  Future<void> initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {},
    );
  }

  notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channelId',
        'channelName',
        // groupKey: "Common Message",
        importance: Importance.max,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

//Show a notification with an optional payload that will be passed back to the app when a notification is tapped.
  Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }

  // Future<void> checkNotificationAppLaunchDetails() async {
  //   InitializationSettings initializationSettings = const InitializationSettings(
  //     android: AndroidInitializationSettings('@drawable/launch_background'),
  //   );
  //   await notificationsPlugin.initialize(initializationSettings);

  //   NotificationAppLaunchDetails? launchDetails = await notificationsPlugin.getNotificationAppLaunchDetails();

  //   if (launchDetails!.didNotificationLaunchApp) {
  //     print('The app was launched via notification!');
  //     print('Notification payload: $launchDetails');
  //   } else {
  //     print('The app was launched normally.');
  //   }
  // }

  Future<void> checkActiveNotifications() async {
    //List<ActiveNotification> activeNotifications = await notificationsPlugin.getActiveNotifications();
    pendingNotification = await notificationsPlugin.pendingNotificationRequests();
    print('length ${pendingNotification.length}');
    for (PendingNotificationRequest notification in pendingNotification) {
      print('Id: ${notification.id}');
      print('Title: ${notification.title}');
      print('Body: ${notification.body}');
      print('Payload: ${notification.payload}');
      print('------------------------');
    }
  }

  Future scheduleNotificationCancelAll() async {
    return notificationsPlugin.cancelAll();
  }

  Future scheduleNotification({
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    pendingNotification = await notificationsPlugin.pendingNotificationRequests();
    return notificationsPlugin.zonedSchedule(
      (pendingNotification.isEmpty ? 0 : pendingNotification.last.id) + 1,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      // ignore: deprecated_member_use
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
