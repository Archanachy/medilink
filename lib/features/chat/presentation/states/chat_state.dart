import 'package:equatable/equatable.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';

enum ChatStatus { initial, connecting, connected, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<MessageEntity> messages;
  final String? errorMessage;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.errorMessage,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<MessageEntity>? messages,
    String? errorMessage,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, messages, errorMessage];
}
