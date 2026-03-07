import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';

/// Background sync service for synchronizing data when app is in background
/// Uses WorkManager for reliable background execution
class BackgroundSyncService {
  BackgroundSyncService._();

  static const String _syncAppointmentsTask = 'syncAppointments';
  static const String _syncMedicalRecordsTask = 'syncMedicalRecords';
  static const String _syncNotificationsTask = 'syncNotifications';
  static const String _syncMessagesTask = 'syncMessages';

  /// Initialize the background sync service
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
    );

    if (kDebugMode) {
      debugPrint('🔄 BackgroundSyncService initialized');
    }
  }

  /// Register periodic sync tasks
  static Future<void> registerPeriodicSync() async {
    // Sync appointments every hour
    await Workmanager().registerPeriodicTask(
      'appointment-sync',
      _syncAppointmentsTask,
      frequency: const Duration(hours: 1),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    // Sync medical records every 6 hours
    await Workmanager().registerPeriodicTask(
      'medical-records-sync',
      _syncMedicalRecordsTask,
      frequency: const Duration(hours: 6),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    // Sync notifications every 30 minutes
    await Workmanager().registerPeriodicTask(
      'notifications-sync',
      _syncNotificationsTask,
      frequency: const Duration(minutes: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    // Sync messages every 30 minutes
    await Workmanager().registerPeriodicTask(
      'messages-sync',
      _syncMessagesTask,
      frequency: const Duration(minutes: 30),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );

    if (kDebugMode) {
      debugPrint('✅ Periodic sync tasks registered');
    }
  }

  /// Register one-time sync task
  static Future<void> registerOneTimeSync(String taskName) async {
    await Workmanager().registerOneOffTask(
      taskName,
      taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );

    if (kDebugMode) {
      debugPrint('✅ One-time sync task registered: $taskName');
    }
  }

  /// Cancel all sync tasks
  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();

    if (kDebugMode) {
      debugPrint('❌ All sync tasks cancelled');
    }
  }

  /// Cancel specific task
  static Future<void> cancelTask(String taskName) async {
    await Workmanager().cancelByUniqueName(taskName);

    if (kDebugMode) {
      debugPrint('❌ Sync task cancelled: $taskName');
    }
  }
}

/// Callback dispatcher for background tasks
/// Must be a top-level function
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 Background task started: $task');
      }

      switch (task) {
        case 'syncAppointments':
          await _syncAppointments();
          break;

        case 'syncMedicalRecords':
          await _syncMedicalRecords();
          break;

        case 'syncNotifications':
          await _syncNotifications();
          break;

        case 'syncMessages':
          await _syncMessages();
          break;

        default:
          if (kDebugMode) {
            debugPrint('⚠️ Unknown background task: $task');
          }
      }

      if (kDebugMode) {
        debugPrint('✅ Background task completed: $task');
      }

      return Future.value(true);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Background task failed: $task - $e');
      }
      return Future.value(false);
    }
  });
}

/// Sync appointments from server
Future<void> _syncAppointments() async {
  // Implementation pending - sync appointments logic
  if (kDebugMode) {
    debugPrint('🔄 Syncing appointments...');
  }

  // Placeholder for actual implementation
  await Future.delayed(const Duration(seconds: 2));

  if (kDebugMode) {
    debugPrint('✅ Appointments synced');
  }
}

/// Sync medical records from server
Future<void> _syncMedicalRecords() async {
  // Implementation pending - sync medical records logic
  if (kDebugMode) {
    debugPrint('🔄 Syncing medical records...');
  }

  // Placeholder for actual implementation
  await Future.delayed(const Duration(seconds: 2));

  if (kDebugMode) {
    debugPrint('✅ Medical records synced');
  }
}

/// Sync notifications from server
Future<void> _syncNotifications() async {
  // Implementation pending - sync notifications logic
  if (kDebugMode) {
    debugPrint('🔄 Syncing notifications...');
  }

  // Placeholder for actual implementation
  await Future.delayed(const Duration(seconds: 1));

  if (kDebugMode) {
    debugPrint('✅ Notifications synced');
  }
}

/// Sync messages from server
Future<void> _syncMessages() async {
  // Implementation pending - sync messages logic
  if (kDebugMode) {
    debugPrint('🔄 Syncing messages...');
  }

  // Placeholder for actual implementation
  await Future.delayed(const Duration(seconds: 1));

  if (kDebugMode) {
    debugPrint('✅ Messages synced');
  }
}
