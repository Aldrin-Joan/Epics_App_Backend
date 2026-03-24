import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/providers/chat_controller.dart';
import 'package:flutter_application_1/widgets/chat_bubble.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AIChatScreen extends ConsumerStatefulWidget {
  const AIChatScreen({super.key});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  String? _recordingPath;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _recorder.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Auto-scroll to bottom when new messages arrive ─────────────────────────
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Text send ──────────────────────────────────────────────────────────────
  void _send() {
    if (_controller.text.trim().isEmpty) return;
    ref.read(chatProvider.notifier).sendTextMessage(_controller.text);
    _controller.clear();
    _scrollToBottom();
  }

  // ── Voice recording ────────────────────────────────────────────────────────
  Future<void> _startRecording() async {
    // Request mic permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission is required for voice queries.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_query_${DateTime.now().millisecondsSinceEpoch}.m4a';

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _recordingPath = path;
    });
  }

  Future<void> _stopRecordingAndSend() async {
    final path = await _recorder.stop();
    setState(() => _isRecording = false);

    if (path == null) return;
    final audioFile = File(path);
    if (!await audioFile.exists()) return;

    ref.read(chatProvider.notifier).sendVoiceMessage(audioFile);
    _scrollToBottom();
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messages = ref.watch(chatProvider);

    // Scroll to bottom on new messages
    _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          l10n.aiChat,
          style: GoogleFonts.sora(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimaryLight,
          ),
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
      ),
      body: Column(
        children: [
          // ── Chat messages ───────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: messages[index]);
              },
            ),
          ),

          // ── Input bar ───────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.backgroundLight,
              border: const Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // ── Mic Button ─────────────────────────────────────────────────
                GestureDetector(
                  onTap: _isRecording ? _stopRecordingAndSend : _startRecording,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      final scale = _isRecording ? _pulseAnimation.value : 1.0;
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _isRecording
                                ? Colors.red.shade50
                                : AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isRecording
                                  ? Colors.red
                                  : const Color(0xFFE2E8F0),
                              width: 2,
                            ),
                            boxShadow: _isRecording
                                ? [
                                    BoxShadow(
                                      color: Colors.red.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    )
                                  ]
                                : [],
                          ),
                          child: Icon(
                            _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                            color: _isRecording
                                ? Colors.red
                                : AppColors.textSecondaryLight,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // ── Text input ─────────────────────────────────────────────────
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
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: _isRecording
                            ? '🔴 Recording... tap ■ to stop'
                            : 'Ask a legal question...',
                        hintStyle: GoogleFonts.sora(
                          color: _isRecording
                              ? Colors.red
                              : AppColors.textSecondaryLight,
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
                      enabled: !_isRecording,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // ── Send Button ────────────────────────────────────────────────
                GestureDetector(
                  onTap: _isRecording ? null : _send,
                  child: AnimatedOpacity(
                    opacity: _isRecording ? 0.4 : 1.0,
                    duration: const Duration(milliseconds: 200),
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
