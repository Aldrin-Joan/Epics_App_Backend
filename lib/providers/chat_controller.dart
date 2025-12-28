import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/models/chat_message.dart';

class ChatController extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() => const [
    ChatMessage(
      role: ChatRole.ai,
      content:
          'Hello! I am your Legal AI assistant. How can I help you with your case details today?',
    ),
  ];

  void sendMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    state = [
      ...state,
      ChatMessage(role: ChatRole.user, content: trimmed),
      const ChatMessage(
        role: ChatRole.ai,
        content: 'Thinking... (Placeholder response)',
      ),
    ];
  }
}

final chatProvider = NotifierProvider<ChatController, List<ChatMessage>>(
  ChatController.new,
);
