import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:medilink/features/chat/domain/entities/conversation_entity.dart';
import 'package:medilink/features/chat/domain/repositories/chat_repository.dart';

final getConversationsUsecaseProvider = Provider<GetConversationsUsecase>((ref) {
  return GetConversationsUsecase(ref.read(chatRepositoryProvider));
});

class GetConversationsUsecase implements UsecaseWithParams<List<ConversationEntity>, String> {
  final IChatRepository _repository;

  GetConversationsUsecase(this._repository);

  @override
  Future<Either<Failure, List<ConversationEntity>>> call(String params) {
    return _repository.getConversations(params);
  }
}
