import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/usecases/app_usecase.dart';
import 'package:medilink/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';
import 'package:medilink/features/chat/domain/repositories/chat_repository.dart';

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  return SendMessageUsecase(ref.read(chatRepositoryProvider));
});

class SendMessageUsecase implements UsecaseWithParams<bool, MessageEntity> {
  final IChatRepository _repository;

  SendMessageUsecase(this._repository);

  @override
  Future<Either<Failure, bool>> call(MessageEntity params) {
    return _repository.sendMessage(params);
  }
}
