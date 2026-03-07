import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medilink/features/chat/domain/entities/conversation_entity.dart';
import 'package:medilink/features/chat/domain/repositories/chat_repository.dart';
import 'package:medilink/features/chat/data/repositories/chat_repository_impl.dart';

final conversationListViewModelProvider = NotifierProvider<ConversationListViewModel, ConversationListState>(
  ConversationListViewModel.new,
);

class ConversationListViewModel extends Notifier<ConversationListState> {
  late final IChatRepository _chatRepository;

  @override
  ConversationListState build() {
    _chatRepository = ref.read(chatRepositoryProvider);
    return const ConversationListState();
  }

  Future<void> loadConversations(String userId) async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);
    
    final result = await _chatRepository.getConversations(userId);
    
    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: failure.message,
        );
      },
      (conversations) {
        // Sort by most recent message (create a mutable copy first)
        final sortedConversations = conversations.toList();
        sortedConversations.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        state = state.copyWith(
          isLoading: false,
          conversations: sortedConversations,
          hasError: false,
          errorMessage: null,
        );
      },
    );
  }

  Future<void> refresh(String userId) async {
    await loadConversations(userId);
  }
}

class ConversationListState {
  final bool isLoading;
  final List<ConversationEntity> conversations;
  final bool hasError;
  final String? errorMessage;

  const ConversationListState({
    this.isLoading = false,
    this.conversations = const [],
    this.hasError = false,
    this.errorMessage,
  });

  ConversationListState copyWith({
    bool? isLoading,
    List<ConversationEntity>? conversations,
    bool? hasError,
    String? errorMessage,
  }) {
    return ConversationListState(
      isLoading: isLoading ?? this.isLoading,
      conversations: conversations ?? this.conversations,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
