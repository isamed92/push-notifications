part of 'notifications_bloc.dart';

abstract class NotificationsEvent {
  const NotificationsEvent();
}

class NotificationChange extends NotificationsEvent {
  final AuthorizationStatus status;
  const NotificationChange(this.status);
}
