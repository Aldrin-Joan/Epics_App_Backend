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

// ONLY UI CHANGED — LOGIC SAME

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

    ref
        .read(lawyerToClientChatProvider.notifier)
        .addMessage(ChatMessage(content: messageText, role: ChatRole.lawyer));

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      ref.read(lawyerToClientChatProvider.notifier).addMessage(
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      /// 🔥 MODERN APPBAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              child: Icon(Icons.person, size: 18),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Client Name 1",
                  style: GoogleFonts.sora(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Online",
                  style: GoogleFonts.sora(
                    fontSize: 11,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.videocam_outlined),
          ),
        ],
      ),

      body: Column(
        children: [
          /// 💬 CHAT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.role == ChatRole.lawyer;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ChatBubble(
                    message: msg,
                    isMeOverride: isMe,
                  ),
                );
              },
            ),
          ),

          /// ✨ MODERN INPUT BAR
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF0F172A)
                  : Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.15),
                ),
              ),
            ),
            child: Row(
              children: [
                /// TEXT FIELD (ROUNDED)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.add, size: 20, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            style: GoogleFonts.sora(
                              fontSize: 14,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: GoogleFonts.sora(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                        const Icon(Icons.mic_none, size: 20, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                /// SEND BUTTON (FLOATING STYLE)
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send, color: Colors.white, size: 20),
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