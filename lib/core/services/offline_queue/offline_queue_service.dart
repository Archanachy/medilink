import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';
import 'package:medilink/core/services/connectivity/network_info.dart';
import 'package:medilink/core/services/offline_queue/models/queued_action.dart';
import 'package:uuid/uuid.dart';

class OfflineQueueService {
  static final OfflineQueueService _instance = OfflineQueueService._internal();
  factory OfflineQueueService() => _instance;
  OfflineQueueService._internal();

  Box<QueuedAction>? _queueBox;
  final NetworkInfo _networkInfo = NetworkInfo(Connectivity());
  StreamSubscription? _syncSubscription;
  bool _isSyncing = false;

  Future<void> initialize() async {
    try {
      _queueBox = await Hive.openBox<QueuedAction>(
        HiveTableConstant.queuedActionTable,
      );
      _startAutoSync();
    } catch (e) {
      debugPrint('Error initializing offline queue: $e');
    }
  }

  void _startAutoSync() {
    // Check for pending actions every 30 seconds when online
    _syncSubscription?.cancel();
    _syncSubscription = Stream.periodic(const Duration(seconds: 30)).listen((_) {
      syncPendingActions();
    });
  }

  Future<String> queueAction({
    required String actionType,
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    if (_queueBox == null) {
      await initialize();
    }

    final action = QueuedAction(
      id: const Uuid().v4(),
      actionType: actionType,
      endpoint: endpoint,
      data: data,
      createdAt: DateTime.now(),
      status: 'pending',
    );

    await _queueBox!.put(action.id, action);
    debugPrint('📥 Queued action: $actionType (${action.id})');

    // Try to sync immediately if online
    syncPendingActions();

    return action.id;
  }

  Future<void> syncPendingActions() async {
    if (_isSyncing || _queueBox == null) return;
    if (!await _networkInfo.isConnected) {
      debugPrint('⚠️ Offline - skipping sync');
      return;
    }

    _isSyncing = true;
    debugPrint('🔄 Starting sync of pending actions...');

    try {
      final pendingActions = _queueBox!.values
          .where((action) => action.status == 'pending')
          .toList();

      for (final action in pendingActions) {
        try {
          await _syncAction(action);
        } catch (e) {
          debugPrint('❌ Failed to sync action ${action.id}: $e');
        }
      }

      debugPrint('✅ Sync completed');
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncAction(QueuedAction action) async {
    // Update status to syncing
    final updatedAction = action.copyWith(status: 'syncing');
    await _queueBox!.put(action.id, updatedAction);

    // Here you would make the actual API call
    // For now, we'll mark it as completed after a delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mark as completed
    final completedAction = updatedAction.copyWith(status: 'completed');
    await _queueBox!.put(action.id, completedAction);
    
    debugPrint('✅ Synced action: ${action.actionType}');

    // Remove completed actions older than 24 hours
    await _cleanupOldActions();
  }

  Future<void> _cleanupOldActions() async {
    final cutoffDate = DateTime.now().subtract(const Duration(hours: 24));
    final toDelete = _queueBox!.values
        .where((action) =>
            action.status == 'completed' && action.createdAt.isBefore(cutoffDate))
        .map((action) => action.id)
        .toList();

    for (final id in toDelete) {
      await _queueBox!.delete(id);
    }
  }

  List<QueuedAction> getPendingActions() {
    return _queueBox?.values
            .where((action) => action.status == 'pending')
            .toList() ??
        [];
  }

  int getPendingCount() {
    return getPendingActions().length;
  }

  Future<void> clearCompleted() async {
    final completed = _queueBox?.values
        .where((action) => action.status == 'completed')
        .map((action) => action.id)
        .toList();

    if (completed != null) {
      for (final id in completed) {
        await _queueBox!.delete(id);
      }
    }
  }

  void dispose() {
    _syncSubscription?.cancel();
  }
}
