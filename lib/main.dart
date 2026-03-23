import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:flutter_application_1/screens/auth_screen.dart';
import 'package:flutter_application_1/screens/client_dashboard.dart';
import 'package:flutter_application_1/screens/lawyer_dashboard.dart';
import 'package:flutter_application_1/screens/lawyer_profile_screen.dart';
import 'package:flutter_application_1/screens/ai_chat_screen.dart';
import 'package:flutter_application_1/screens/upload_screen.dart';
import 'package:flutter_application_1/screens/find_lawyers_screen.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/lawyer_chat_screen.dart';
import 'package:flutter_application_1/screens/payment_method.dart';
import 'package:flutter_application_1/screens/notification_screen.dart';
import 'package:flutter_application_1/screens/help_support_screen.dart';
import 'package:flutter_application_1/screens/privacy_security_screen.dart';
import 'package:flutter_application_1/screens/lawyer_to_client_chat_screen.dart';
import 'package:flutter_application_1/screens/personal_info_screen.dart';
import 'package:flutter_application_1/providers/language_provider.dart';
import 'package:flutter_application_1/providers/theme_provider.dart'; 
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/theme/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: LegalTechApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth',
    routes: [
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/client',
        builder: (context, state) => const ClientDashboard(),
      ),
      GoRoute(
        path: '/lawyer',
        builder: (context, state) => const LawyerDashboard(),
      ),
      GoRoute(
        path: '/ai-chat',
        builder: (context, state) => const AIChatScreen(),
      ),
      GoRoute(
        path: '/upload',
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/find-lawyers',
        builder: (context, state) => const FindLawyersScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/lawyer-chat',
        builder: (context, state) => const LawyerChatScreen(),
      ),
      GoRoute(
        path: '/lawyer-to-client-chat',
        builder: (context, state) =>
            const LawyerToClientChatScreen(),
      ),
      GoRoute(
  path: '/lawyer-profile',
  builder: (context, state) => const LawyerProfileScreen(),
),
      GoRoute(
        path: '/personal-info',
       builder: (context, state) => 
       const PersonalInfoScreen(),
      ),
      GoRoute(path: '/security', builder: (_, _) => const SecurityScreen()),
GoRoute(path: '/payments', builder: (_, _) => const PaymentScreen()),
GoRoute(path: '/notifications', builder: (_, _) => const NotificationScreen()),
GoRoute(path: '/help', builder: (_, _) => const HelpScreen()),
    ],
  );
});

class LegalTechApp extends ConsumerWidget {
  const LegalTechApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider); 

    return MaterialApp.router(
      title: 'LegalTech Super App',
      locale: locale,
      themeMode: themeMode, 
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
        Locale('hi'),
        Locale('ml'),
        Locale('kn'),
        Locale('te'),
      ],
    );
  }

  /// 🌞 LIGHT THEME
  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
        background: AppColors.backgroundLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primary,
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimaryLight,
        centerTitle: true,
      ),
      textTheme:
          GoogleFonts.soraTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: AppColors.textPrimaryLight,
        displayColor: AppColors.textPrimaryLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: AppColors.cardElevation,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 2,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFFE2E8F0), width: 2),
        ),
      ),
    );
  }

  /// 🌙 DARK THEME
  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: AppColors.primaryLight,
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimaryDark,
        centerTitle: true,
      ),
      textTheme:
          GoogleFonts.soraTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: AppColors.textPrimaryDark,
        displayColor: AppColors.textPrimaryDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: AppColors.cardElevation,
        shadowColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.textPrimaryLight,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.sora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.backgroundDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}