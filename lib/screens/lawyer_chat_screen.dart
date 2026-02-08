import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/widgets/chat_bubble.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/models/chat_message.dart';

// Using Notifier instead of StateProvider for consistency
class LawyerChatNotifier extends Notifier<List<ChatMessage>> {
  @override
  List<ChatMessage> build() {
    return [
      const ChatMessage(
        content: "Hello, how can I help you with your property query?",
        role: ChatRole.lawyer,
      ),
    ];
  }

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }
}

final lawyerChatProvider =
    NotifierProvider<LawyerChatNotifier, List<ChatMessage>>(
      LawyerChatNotifier.new,
    );

class LawyerChatScreen extends ConsumerStatefulWidget {
  const LawyerChatScreen({super.key});

  @override
  ConsumerState<LawyerChatScreen> createState() => _LawyerChatScreenState();
}

class _LawyerChatScreenState extends ConsumerState<LawyerChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    if (_controller.text.trim().isEmpty) return;

    final messageText = _controller.text;
    _controller.clear();

    // Add user message via notifier
    ref
        .read(lawyerChatProvider.notifier)
        .addMessage(ChatMessage(content: messageText, role: ChatRole.user));

    // Simulate lawyer response
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ref
          .read(lawyerChatProvider.notifier)
          .addMessage(
            const ChatMessage(
              content:
                  "I see. Could you provide more details about the contract?",
              role: ChatRole.lawyer,
            ),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(lawyerChatProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              "Adv. Sarah Jenkins",
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
                return ChatBubble(message: messages[index]);
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
