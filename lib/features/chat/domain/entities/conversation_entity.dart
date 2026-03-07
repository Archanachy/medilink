import 'package:equatable/equatable.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';

class ConversationEntity extends Equatable {
  final String id;
  final List<String> participantIds;
  final MessageEntity? lastMessage;
  final DateTime updatedAt;
  final int unreadCount;

  const ConversationEntity({
    required this.id,
    required this.participantIds,
    this.lastMessage,
    required this.updatedAt,
    this.unreadCount = 0,
  });

  @override
  List<Object?> get props => [id, participantIds, lastMessage, updatedAt, unreadCount];
}
