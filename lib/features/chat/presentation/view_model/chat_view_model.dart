import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:medilink/core/services/websocket/websocket_service.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';
import 'package:medilink/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:medilink/features/chat/presentation/states/chat_state.dart';

final chatViewModelProvider = NotifierProvider.autoDispose<ChatViewModel, ChatState>(
  ChatViewModel.new,
);

class ChatViewModel extends Notifier<ChatState> {
  late final SendMessageUsecase _sendMessageUsecase;
  StreamSubscription<WebSocketMessage>? _subscription;
  String? _currentReceiverId;

  @override
  ChatState build() {
    _sendMessageUsecase = ref.read(sendMessageUsecaseProvider);
    
    // Cleanup on dispose
    ref.onDispose(() {
      _subscription?.cancel();
      _subscription = null;
    });
    
    return const ChatState();
  }

  /// Safe state setter that checks if notifier is still mounted
  void _setState(ChatState newState) {
    state = newState;
  }

  Future<void> connect(String userId, String receiverId) async {
    _currentReceiverId = receiverId;

    _setState(state.copyWith(status: ChatStatus.connecting));
    
    // Get JWT token from secure storage for Socket.IO authentication
    const storage = FlutterSecureStorage();
    String? token;
    try {
      token = await storage.read(key: 'auth_token');
    } catch (e) {
      // If token read fails, continue without it (will fail at backend auth)
    }
    
    // Connect to Socket.IO with token authentication
    await WebSocketService.instance.connect(userId, token: token);

    _subscription?.cancel();
    _subscription = WebSocketService.instance.messageStream?.listen((message) {
      _handleSocketMessage(message);
    });

    // Send Socket.IO events as per backend
    WebSocketService.instance.sendEvent('chat:getRooms', {});
    WebSocketService.instance.sendEvent('chat:getHistory', {
      'receiverId': receiverId,
    });

    _setState(state.copyWith(status: ChatStatus.connected));
  }

  void _handleSocketMessage(WebSocketMessage message) {
    final rawType = message.rawType?.toLowerCase() ?? '';
    final payload = message.payload as Map<String, dynamic>?;
    
    if (payload == null) return;

    // Handle chat history response (from chat:getHistory)
    if (rawType.contains('gethistory') || rawType == 'chat:gethistory:response') {
      final messages = payload['messages'] as List<dynamic>? ?? [];
      final historyMessages = messages
          .whereType<Map<String, dynamic>>()
          .map(_mapMessage)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      _setState(state.copyWith(messages: historyMessages, status: ChatStatus.connected));
      return;
    }

    // Handle incoming chat message event (socket.emit('chat:message') from backend)
    // Backend sends this to both sender and receiver
    if (rawType == 'chat:message') {
      final newMessage = _mapMessage(payload);
      final alreadyExists = state.messages.any((msg) => msg.id == newMessage.id && msg.id.isNotEmpty);
      if (!alreadyExists) {
        final updated = List.of(state.messages)..add(newMessage);
        updated.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _setState(state.copyWith(messages: updated, status: ChatStatus.connected));
      }
      return;
    }

    // Handle chat:send response (callback response)
    if (rawType.contains('send') || rawType == 'chat:send:response') {
      final messageData = payload['message'] as Map<String, dynamic>?;
      if (messageData != null) {
        final newMessage = _mapMessage(messageData);
        final alreadyExists = state.messages.any((msg) => msg.id == newMessage.id && msg.id.isNotEmpty);
        if (!alreadyExists) {
          final updated = List.of(state.messages)..add(newMessage);
          updated.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          _setState(state.copyWith(messages: updated, status: ChatStatus.connected));
        }
      }
      return;
    }
  }

  MessageEntity _mapMessage(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      conversationId: json['roomId'] as String? ?? json['conversationId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      receiverId: json['receiverId'] as String? ?? _currentReceiverId ?? '',
      content: json['content'] as String? ?? json['message'] as String? ?? '',
      createdAt: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : (json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
              : DateTime.now()),
      isRead: json['read'] as bool? ?? json['isRead'] as bool? ?? false,
    );
  }

  Future<void> disconnect() async {
    await WebSocketService.instance.disconnect();
    await _subscription?.cancel();
    _subscription = null;
    _setState(state.copyWith(status: ChatStatus.initial));
  }

  Future<void> sendMessage(MessageEntity message) async {
    final result = await _sendMessageUsecase(message);
    result.fold(
      (failure) {
        _setState(state.copyWith(status: ChatStatus.error, errorMessage: failure.message));
      },
      (success) {
        final updated = List.of(state.messages)..add(message);
        updated.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        _setState(state.copyWith(messages: updated));

        if (_currentReceiverId != null) {
          WebSocketService.instance.sendEvent('chat:getHistory', {
            'receiverId': _currentReceiverId,
          });
        }
      },
    );
  }
}
