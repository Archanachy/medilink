import 'package:dartz/dartz.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/features/chat/domain/entities/conversation_entity.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';

abstract interface class IChatRepository {
  Future<void> connect(String userId);
  Future<void> disconnect();

  Future<Either<Failure, bool>> sendMessage(MessageEntity message);
  Future<Either<Failure, List<ConversationEntity>>> getConversations(String userId);
}
