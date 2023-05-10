part of 'notifications_bloc.dart';

class NotificationsState extends Equatable {
  final AuthorizationStatus status;
  final List<dynamic> notifications;

  const NotificationsState(
      {this.status = AuthorizationStatus.notDetermined,
      this.notifications = const []});

  @override
  List<Object> get props => [status, notifications];

  NotificationsState copyWith(
          {AuthorizationStatus? status, List<dynamic>? notifications}) =>
      NotificationsState(
          notifications: notifications ?? this.notifications,
          status: status ?? this.status);
}
