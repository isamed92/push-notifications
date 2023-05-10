import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notifications/domain/entities/push_message.dart';
import 'package:push_notifications/presentation/blocs/notification_bloc/notifications_bloc.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;
  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessage? notification =
        context.watch<NotificationsBloc>().getNotificationById(pushMessageId);
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: notification != null
          ? _DetailsView(notification: notification)
          : const Center(
              child: Text('Esa notificacion no existe'),
            ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage notification;
  const _DetailsView({required this.notification});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        if (notification.imageUrl != null)
          Image.network(notification.imageUrl!),
        const SizedBox(
          height: 20,
        ),
        Text(
          notification.title,
          style: textTheme.titleMedium,
        ),
        Text(
          notification.body,
          style: textTheme.bodySmall,
        ),
        const Divider(),
        Text(notification.data.toString()),
      ]),
    );
  }
}
