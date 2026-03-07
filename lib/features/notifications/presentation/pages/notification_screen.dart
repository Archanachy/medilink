import 'package:flutter/material.dart';
import 'package:medilink/features/notifications/domain/entities/notification_entity.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  List<NotificationEntity> _mockNotifications() {
    return [
      NotificationEntity(
        id: '1',
        title: 'Appointment Reminder',
        body: 'Your appointment is scheduled for tomorrow at 10:00 AM',
        type: 'appointment',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      NotificationEntity(
        id: '2',
        title: 'New Message',
        body: 'You have a new message from Dr. Sharma',
        type: 'chat',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final notifications = _mockNotifications();

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(notification.title),
            subtitle: Text(notification.body),
            trailing: Text(
              notification.createdAt.toLocal().toString().split(' ')[0],
              style: const TextStyle(fontSize: 12),
            ),
          );
        },
      ),
    );
  }
}
