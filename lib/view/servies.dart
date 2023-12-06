import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static List<PendingNotificationRequest> pendingNotification = [];

  static Future initNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) => null,
    );
    const LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName',
          importance: Importance.max, priority: Priority.high, ticker: 'ticker'),
      iOS: DarwinNotificationDetails(),
    );
  }

//Simple notification
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // Future<void> checkNotificationAppLaunchDetails() async {
  //   InitializationSettings initializationSettings = const InitializationSettings(
  //     android: AndroidInitializationSettings('@drawable/launch_background'),
  //   );
  //   await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

  //   NotificationAppLaunchDetails? launchDetails = await _flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  //   if (launchDetails!.didNotificationLaunchApp) {
  //     print('The app was launched via notification!');
  //     print('Notification payload: $launchDetails');
  //   } else {
  //     print('The app was launched normally.');
  //   }
  // }

  Future<void> checkActiveNotifications() async {
    pendingNotification = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
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
    return _flutterLocalNotificationsPlugin.cancelAll();
  }
  
  // ScheduleNotification

  static void scheduleNotification({
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    pendingNotification = await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return _flutterLocalNotificationsPlugin.zonedSchedule(
      (pendingNotification.isEmpty ? 0 : pendingNotification.last.id) + 1,
      title,
      body,
      tz.TZDateTime.from(
        scheduledNotificationDateTime,
        tz.local,
      ),
      await notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payLoad,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future cancel(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
