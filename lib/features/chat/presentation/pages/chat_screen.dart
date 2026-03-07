import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/chat/domain/entities/message_entity.dart';
import 'package:medilink/features/chat/presentation/states/chat_state.dart';
import 'package:medilink/features/chat/presentation/view_model/chat_view_model.dart';
import 'package:medilink/features/chat/presentation/widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final String userId;
  final String conversationId;
  final String receiverId;
  final String? receiverName;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.conversationId,
    required this.receiverId,
    this.receiverName,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(chatViewModelProvider.notifier).connect(
            widget.userId,
            widget.receiverId,
          );
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    // Disconnect handled by ChatViewModel's ref.onDispose()
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    final message = MessageEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      conversationId: widget.conversationId,
      senderId: widget.userId,
      receiverId: widget.receiverId,
      content: content,
      createdAt: DateTime.now(),
    );

    _messageController.clear();
    await ref.read(chatViewModelProvider.notifier).sendMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.receiverName?.trim().isNotEmpty == true ? widget.receiverName! : 'Chat')),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                if (state.status == ChatStatus.connecting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == ChatStatus.error) {
                  return Center(child: Text(state.errorMessage ?? 'Chat error'));
                }
                if (state.messages.isEmpty) {
                  return const Center(child: Text('No messages yet'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.messages.length,
                  itemBuilder: (context, index) {
                    final message = state.messages[index];
                    final isMe = message.senderId == widget.userId;
                    return MessageBubble(message: message, isMe: isMe);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
