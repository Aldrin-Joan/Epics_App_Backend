import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/widgets/chat_bubble.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/models/chat_message.dart';

// Provider for Lawyer-to-Client chat
class LawyerToClientChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      const ChatMessage(
        content: "Hello, could you review these documents?",
        role: ChatRole.user, // Client talking
      ),
    ];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}

final lawyerToClientChatProvider =
    NotifierProvider<LawyerToClientChatNotifier, List<ChatMessage>>(
      LawyerToClientChatNotifier.new,
    );

class LawyerToClientChatScreen extends ConsumerStatefulWidget {
  const LawyerToClientChatScreen({super.key});

  @override
  ConsumerState<LawyerToClientChatScreen> createState() =>
      _LawyerToClientChatScreenState();
}

class _LawyerToClientChatScreenState
    extends ConsumerState<LawyerToClientChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.trim().isEmpty) return;

    final messageText = _controller.text;
    _controller.clear();

    // I am the Lawyer sending a message
    ref
        .read(lawyerToClientChatProvider.notifier)
        .addMessage(ChatMessage(content: messageText, role: ChatRole.lawyer));

    // Simulate Client response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ref
          .read(lawyerToClientChatProvider.notifier)
          .addMessage(
            const ChatMessage(
              content: "Sure, let me check that for you.",
              role: ChatRole.user,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(lawyerToClientChatProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Client Name 1", // Dynamic in real app
              style: GoogleFonts.sora(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimaryLight,
              ),
            ),
            Text(
              "online",
              style: GoogleFonts.sora(
                fontSize: 12,
                color: AppColors.accent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 18,
                color: AppColors.textPrimaryLight,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_rounded, color: AppColors.primary),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_rounded, color: AppColors.primary),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                // If I am Lawyer, 'lawyer' role is ME.
                final isMe = msg.role == ChatRole.lawyer;
                return ChatBubble(message: msg, isMeOverride: isMe);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              border: const Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: GoogleFonts.sora(fontSize: 15),
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        hintStyle: GoogleFonts.sora(
                          color: AppColors.textSecondaryLight,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        filled: false,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _send,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryLight],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
