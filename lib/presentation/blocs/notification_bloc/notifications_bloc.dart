import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/config/local_notifications/local_notification.dart';
import 'package:push_notifications/domain/entities/push_message.dart';
import 'package:push_notifications/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

//! A TOP LEVEL FUNCTION FOR BACKGROUND NOTIFICATIONS
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage msge) async {
  await Firebase.initializeApp();
  // print('handling notification $msge');
}

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationChange>(_notificationStatusChanged);

    // Listener para agregar notificaciones
    on<NotificationReceived>(_onNotificationReceived);

    // Verificar el estado de las notificaciones
    _initialStatusCheck();
    // Listener para las notificaciones en foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFirebaseNotifications() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );
    // solicitar permiso a las local notification
    await requestPermissionLocalNotification();
    add(NotificationChange(settings.authorizationStatus));
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationChange(settings.authorizationStatus));
  }

  void _getFirebaseConfigurationMessagingToken() async {
    if (state.status != AuthorizationStatus.authorized) return;

    final token = await messaging.getToken();

    print(token);
  }

  void _notificationStatusChanged(
      NotificationChange event, Emitter<NotificationsState> emit) {
    emit(state.copyWith(status: event.status));
    _getFirebaseConfigurationMessagingToken();
  }

  void handleRemoteMessage(RemoteMessage message) {
    // print('message is: ${message.data}');

    if (message.notification == null) return;

    final notification = PushMessage(
        messageId:
            message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        sentDate: message.sentTime ?? DateTime.now(),
        data: message.data,
        imageUrl: Platform.isAndroid
            ? message.notification!.android?.imageUrl
            : message.notification!.apple?.imageUrl);

    // print('message also contained a notification $notification');

    add(NotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void _onNotificationReceived(
      NotificationReceived event, Emitter<NotificationsState> emit) {
    emit(state
        .copyWith(notifications: [...state.notifications, event.notification]));
  }

  PushMessage? getNotificationById(String notificationId) {
    final exists = state.notifications
        .any((element) => element.messageId == notificationId);

    if (!exists) return null;

    return state.notifications
        .firstWhere((element) => element.messageId == notificationId);
  }
}
