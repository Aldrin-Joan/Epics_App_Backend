import 'package:flutter/material.dart';

/// Centralized color tokens for the app.
/// Works with Material 3 + light/dark themes.
abstract final class AppColors {
  // ===== Brand =====
  static const Color primary = Color(0xFF6C5CE7); // Neon purple
  static const Color primaryContainer = Color(0xFFE6E3FF);

  static const Color accent = Color(0xFF00E5C9); // Neon teal
  static const Color accentContainer = Color(0xFFCCFBF4);

  static const Color warm = Color(0xFFFFD166); // Highlight / warning

  // ===== Neutral / Surfaces =====
  static const Color backgroundLight = Color(0xFFF8F7FF);
  static const Color backgroundDark = Color(0xFF0F1020);

  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A1B2E);

  // ===== Text =====
  static const Color textPrimaryLight = Color(0xFF1C1B1F);
  static const Color textPrimaryDark = Color(0xFFE6E6F0);

  static const Color textSecondaryLight = Color(0xFF5F5B6B);
  static const Color textSecondaryDark = Color(0xFFB5B4C2);

  // ===== Status =====
  static const Color success = Color(0xFF2ECC71);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);

  // ===== Effects =====
  static const Color cardShadow = Color.fromRGBO(
    0,
    0,
    0,
    0.08,
  ); // Subtle elevation

  static const double cardElevation = 1.5;
}
