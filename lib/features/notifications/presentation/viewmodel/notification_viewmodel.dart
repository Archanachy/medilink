import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/notifications/domain/entities/notification_entity.dart';
import 'package:medilink/features/notifications/presentation/state/notification_state.dart';

final notificationViewmodelProvider =
    NotifierProvider<NotificationViewmodel, NotificationState>(
        () => NotificationViewmodel());

class NotificationViewmodel extends Notifier<NotificationState> {
  @override
  NotificationState build() {
    loadNotifications();
    return const NotificationState();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(status: NotificationStatus.loading);

    try {
      // Mock data for now - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      final mockNotifications = [
        NotificationEntity(
          id: '1',
          title: 'Appointment Reminder',
          body: 'Your appointment is scheduled for tomorrow at 10:00 AM',
          type: 'appointment',
          createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
        ),
        NotificationEntity(
          id: '2',
          title: 'Prescription Ready',
          body: 'Your prescription is ready for pickup',
          type: 'prescription',
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
        ),
        NotificationEntity(
          id: '3',
          title: 'Payment Confirmation',
          body: 'Your payment of \$50 has been confirmed',
          type: 'payment',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
        NotificationEntity(
          id: '4',
          title: 'Lab Results Available',
          body: 'Your lab results are now available',
          type: 'reminder',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          isRead: false,
        ),
        NotificationEntity(
          id: '5',
          title: 'New Message',
          body: 'You have a new message from Dr. Sharma',
          type: 'appointment',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          isRead: true,
        ),
      ];

      state = state.copyWith(
        status: NotificationStatus.loaded,
        notifications: mockNotifications,
      );
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to load notifications: $e',
      );
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      // API integration pending - PUT /notifications/:id/read
      
      final updatedNotifications = state.notifications.map((notification) {
        if (notification.id == notificationId) {
          return NotificationEntity(
            id: notification.id,
            title: notification.title,
            body: notification.body,
            type: notification.type,
            createdAt: notification.createdAt,
            isRead: true,
          );
        }
        return notification;
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to mark notification as read: $e',
      );
    }
  }

  Future<void> markAllAsRead() async {
    try {
      // API integration pending - PUT /notifications/mark-all-read
      
      final updatedNotifications = state.notifications.map((notification) {
        return NotificationEntity(
          id: notification.id,
          title: notification.title,
          body: notification.body,
          type: notification.type,
          createdAt: notification.createdAt,
          isRead: true,
        );
      }).toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to mark all notifications as read: $e',
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      // API integration pending - DELETE /notifications/:id
      
      final updatedNotifications = state.notifications
          .where((notification) => notification.id != notificationId)
          .toList();

      state = state.copyWith(notifications: updatedNotifications);
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to delete notification: $e',
      );
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      // API integration pending - DELETE /notifications/all
      
      state = state.copyWith(notifications: []);
    } catch (e) {
      state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: 'Failed to delete all notifications: $e',
      );
    }
  }

  Future<void> refresh() async {
    await loadNotifications();
  }
}
