

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lafyamind_app/src/features/home/chatbot/domain/chat_message.dart';

class ChatMessagesNotifier extends StateNotifier<List<ChatMessage>> {
  ChatMessagesNotifier() : super([]);

  void addUserMessage(String text) {
    state = [...state, ChatMessage(text: text, isUser: true)];
  }

  void addBotMessage(String text) {
    state = [...state, ChatMessage(text: text, isUser: false)];
  }

  void clearMessages() {
    state = [];
  }
}

final chatMessagesProvider = StateNotifierProvider<ChatMessagesNotifier, List<ChatMessage>>((ref) {
  return ChatMessagesNotifier();
});