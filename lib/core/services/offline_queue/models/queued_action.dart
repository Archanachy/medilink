import 'package:hive/hive.dart';
import 'package:medilink/core/constants/hive_table_constant.dart';

part 'queued_action.g.dart';

@HiveType(typeId: HiveTableConstant.queuedActionTypeId)
class QueuedAction extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String actionType;

  @HiveField(2)
  final String endpoint;

  @HiveField(3)
  final Map<String, dynamic> data;

  @HiveField(4)
  final DateTime createdAt;

  @HiveField(5)
  final String status; // pending, syncing, completed, failed

  @HiveField(6)
  final int retryCount;

  @HiveField(7)
  final String? errorMessage;

  QueuedAction({
    required this.id,
    required this.actionType,
    required this.endpoint,
    required this.data,
    required this.createdAt,
    this.status = 'pending',
    this.retryCount = 0,
    this.errorMessage,
  });

  QueuedAction copyWith({
    String? status,
    int? retryCount,
    String? errorMessage,
  }) {
    return QueuedAction(
      id: id,
      actionType: actionType,
      endpoint: endpoint,
      data: data,
      createdAt: createdAt,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
