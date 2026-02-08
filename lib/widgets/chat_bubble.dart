import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/chat_message.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool? isMeOverride;

  const ChatBubble({super.key, required this.message, this.isMeOverride});

  @override
  Widget build(BuildContext context) {
    final isUserRole = message.role == ChatRole.user;
    final isLawyerScale = message.role == ChatRole.lawyer;
    final isAI = message.role == ChatRole.ai;

    // Determine if this message is "Mine" (Sent by me)
    // Default: 'User' role is Me.
    // If override provided, use that.
    final isMe = isMeOverride ?? isUserRole; // Use the field from the class
    final isReceived = !isMe;

    Color? getBackgroundColor() {
      if (isMe) return AppColors.surfaceLight;
      if (isAI) return null;
      if (isLawyerScale) return null;
      return Colors.white;
    }

    Gradient? getGradient() {
      if (isMe) return null;
      if (isAI) {
        return const LinearGradient(
          colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }
      if (isLawyerScale) {
        return const LinearGradient(
          colors: [Color(0xFFF0FDF4), Color(0xFFDCFCE7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      }
      return null;
    }

    Color getBorderColor() {
      if (isMe) return const Color(0xFFE2E8F0);
      if (isAI) return const Color(0xFFC7D2FE);
      if (isLawyerScale) return const Color(0xFFBBF7D0);
      return const Color(0xFFE2E8F0);
    }

    // Header Logic
    // Only show header if it's received AND (it's AI OR it's Lawyer).
    // If it's a User (Client) sending to Lawyer, maybe we show their name?
    // For now, let's just show header for AI and Lawyer for consistency with previous designs.
    // If we are Lawyer viewing Client message, we might want to hide header or show "Client Name".
    bool showHeader = isReceived && (isAI || isLawyerScale);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.85,
        ),
        decoration: BoxDecoration(
          color: getBackgroundColor(),
          gradient: getGradient(),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isMe ? const Radius.circular(20) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(20),
          ),
          border: Border.all(color: getBorderColor(), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isAI ? Icons.smart_toy_rounded : Icons.gavel_rounded,
                      size: 14,
                      color: isAI ? AppColors.primary : AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isAI ? "Legal AI" : "Adv. Sarah Jenkins",
                    style: GoogleFonts.sora(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isAI ? AppColors.primary : AppColors.accent,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message.content,
              style: GoogleFonts.sora(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textPrimaryLight,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
