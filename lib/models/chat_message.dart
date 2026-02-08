enum ChatRole { user, ai, lawyer }

class ChatMessage {
  final ChatRole role;
  final String content;

  const ChatMessage({required this.role, required this.content});
}
