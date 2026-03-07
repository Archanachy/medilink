import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/core/api/api_client.dart';
import 'package:medilink/core/api/api_endpoints.dart';
import 'package:medilink/core/error/failures.dart';
import 'package:medilink/core/services/websocket/websocket_service.dart';
import 'package:medilink/features/chat/domain/entities/conversation_entity.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';
import 'package:medilink/features/chat/domain/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  return ChatRepositoryImpl(
    apiClient: ref.read(apiClientProvider),
    socketService: WebSocketService.instance,
  );
});

class ChatRepositoryImpl implements IChatRepository {
  final ApiClient _apiClient;
  final WebSocketService _socketService;

  ChatRepositoryImpl({
    required ApiClient apiClient,
    required WebSocketService socketService,
  })  : _apiClient = apiClient,
        _socketService = socketService;

  @override
  Future<void> connect(String userId) async {
    await _socketService.connect(userId);
  }

  @override
  Future<void> disconnect() async {
    await _socketService.disconnect();
  }

  @override
  Future<Either<Failure, bool>> sendMessage(MessageEntity message) async {
    try {
      // Match backend event name: chat:send
      // Backend expects: { receiverId, content }
      _socketService.sendEvent('chat:send', {
        'receiverId': message.receiverId,
        'content': message.content,
      });
      return const Right(true);
    } catch (e) {
      return const Left(ApiFailure(message: 'Failed to send message'));
    }
  }

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations(
    String userId,
  ) async {
    final endpoints = <String>[
      ApiEndpoints.conversations,
      '/messages/conversations',
      '/api/messages/conversations',
      '/auth/messages/conversations',
      '/api/chat/rooms',
      '/auth/chat/conversations',
    ];

    final queryParamCandidates = <Map<String, dynamic>>[
      {'userId': userId},
      {'patientId': userId},
      {'participantId': userId},
    ];

    DioException? lastDioError;

    for (final endpoint in endpoints) {
      for (final query in queryParamCandidates) {
        try {
          final response = await _apiClient.get(
            endpoint,
            queryParameters: query,
          );

          final payload = response.data;
          final rawList = payload is Map<String, dynamic>
              ? payload['data'] as List<dynamic>? ?? <dynamic>[]
              : payload is List<dynamic>
                  ? payload
                  : <dynamic>[];

          final conversations = rawList
              .whereType<Map<String, dynamic>>()
              .map(_mapConversation)
              .toList();

          return Right(conversations);
        } on DioException catch (e) {
          lastDioError = e;
          if (e.response?.statusCode == 404) {
            continue;
          }
          return const Left(ApiFailure(message: 'Failed to load conversations'));
        } catch (e) {
          return const Left(ApiFailure(message: 'Failed to load conversations'));
        }
      }
    }

    if (lastDioError?.response?.statusCode == 404) {
      return const Right([]);
    }

    return const Left(ApiFailure(message: 'Failed to load conversations'));
  }

  ConversationEntity _mapConversation(Map<String, dynamic> json) {
    final lastMessageJson = json['lastMessage'] as Map<String, dynamic>?;
    final lastMessage = lastMessageJson == null
        ? null
        : MessageEntity(
            id: lastMessageJson['_id'] as String? ?? '',
            conversationId: json['_id'] as String? ?? '',
            senderId: lastMessageJson['senderId'] as String? ?? '',
            receiverId: lastMessageJson['receiverId'] as String? ?? '',
            content: lastMessageJson['content'] as String? ?? '',
            createdAt: lastMessageJson['createdAt'] != null
                ? DateTime.parse(lastMessageJson['createdAt'] as String)
                : DateTime.now(),
            isRead: lastMessageJson['isRead'] as bool? ?? false,
          );

    return ConversationEntity(
      id: json['_id'] as String? ?? '',
      participantIds: (json['participants'] as List<dynamic>? ?? [])
          .map((id) => id.toString())
          .toList(),
      lastMessage: lastMessage,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}
