import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:push_notifications/config/router/app_router.dart';

class LocalNotifications {
  static Future<void> requestPermissionLocalNotification() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeLocalNotifications() async {
    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();

    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    const initializationSettingsDarwin = DarwinInitializationSettings(
        onDidReceiveLocalNotification: darwinShowNotification);
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static void showLocalNotification({
    required int id,
    String? title,
    String? body,
    String? data,
  }) {
    const androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName',
        playSound: true, importance: Importance.max, priority: Priority.high);
    const darwinNotificationDetails =
        DarwinNotificationDetails(presentSound: true);
    const notificationDetails = NotificationDetails(
        android: androidDetails, iOS: darwinNotificationDetails);
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails,
        payload: data);
  }

  static void darwinShowNotification(
      int id, String? title, String? body, String? data) {
    showLocalNotification(id: id, title: title, body: body, data: data);
  }

  static void onDidReceiveNotificationResponse(NotificationResponse response) {
    appRouter.push('/notification/${response.payload}');
  }
}
