import 'dart:io';
import 'package:dio/dio.dart';

/// Service for communicating with the FastAPI voice pipeline.
///
/// Backend endpoints used:
///   POST /legal/voice-query  → STT + KG + LLM + TTS
///   GET  /legal/audio/{name} → Serve generated MP3
class VoiceApiService {
  // ── Base URL ────────────────────────────────────────────────────────────────
  // 10.0.2.2 = localhost on Android emulator.
  // For a real device on the same WiFi, set this to your machine's local IP,
  // e.g. "http://192.168.1.42:8000"
  static const String _baseUrl = 'http://10.0.2.2:8000';

  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120), // Whisper can be slow
    ),
  );

  /// Result from [sendVoiceQuery]. All fields nullable to handle partial errors.
  static const String audioBaseUrl = _baseUrl;

  /// Send an audio file to the backend voice-query endpoint.
  ///
  /// Returns a map with keys:
  ///   - `transcription`  : original-language text from Whisper
  ///   - `answer_text`    : translated answer from LLM (in original language)
  ///   - `audio_url`      : relative URL like "/legal/audio/response_xxx.mp3"
  ///   - `sources`        : list of KG/RAG source strings
  static Future<Map<String, dynamic>> sendVoiceQuery(File audioFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        audioFile.path,
        filename: audioFile.path.split(Platform.pathSeparator).last,
      ),
      // Let the backend auto-detect the language from Whisper output
    });

    final response = await _dio.post('/legal/voice-query', data: formData);

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Voice query failed: ${response.statusCode} ${response.data}');
    }
  }

  /// Send a plain-text message to the AI chat endpoint.
  static Future<Map<String, dynamic>> sendTextQuery(String message) async {
    final response = await _dio.post(
      '/legal/ai-chat',
      data: {'message': message},
    );

    if (response.statusCode == 200) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception('Text query failed: ${response.statusCode}');
    }
  }

  /// Build the full audio URL from the relative path returned by the backend.
  static String buildAudioUrl(String relativeAudioUrl) {
    return '$_baseUrl$relativeAudioUrl';
  }
}
