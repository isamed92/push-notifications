import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_notifications/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    on<NotificationChange>(_notificationStatusChanged);

    _initialStatusCheck();
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
}
