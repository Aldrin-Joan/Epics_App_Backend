import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/language_provider.dart';
import 'package:flutter_application_1/providers/auth_ui_controller.dart';
import 'package:flutter_application_1/theme/app_colors.dart';
import 'package:flutter_application_1/widgets/gradient_button.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(authUiProvider);
    final controller = ref.read(authUiProvider.notifier);

    final isLogin = state.mode == AuthMode.login;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667EEA), // Wireframe gradient start
              Color(0xFF764BA2), // Wireframe gradient end
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Language Selector
              Positioned(top: 20, right: 20, child: const LanguageSelector()),

              // Main Content
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      elevation: 20,
                      shadowColor: Colors.black26,
                      color: AppColors.surfaceLight,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              l10n.welcomeMessage,
                              style: GoogleFonts.sora(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryLight,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              isLogin
                                  ? "Please enter your details." // TODO: Add to l10n
                                  : "create an account to get started.", // TODO: Add to l10n
                              style: GoogleFonts.sora(
                                fontSize: 16,
                                color: AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w300,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),

                            // Email
                            TextField(
                              decoration: InputDecoration(
                                labelText: l10n.email,
                                hintText: 'Enter your email',
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Full Name (Signup only)
                            if (!isLogin) ...[
                              TextField(
                                decoration: InputDecoration(
                                  labelText: l10n.fullName,
                                  hintText: 'Enter your full name',
                                  prefixIcon: const Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Password
                            TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: l10n.password,
                                hintText: '••••••••',
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Role Selector
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundLight,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => controller.selectRole(
                                        UserRole.client,
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.role == UserRole.client
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow:
                                              state.role == UserRole.client
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          l10n.client,
                                          style: GoogleFonts.sora(
                                            fontSize: 14,
                                            fontWeight:
                                                state.role == UserRole.client
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            color: state.role == UserRole.client
                                                ? AppColors.primary
                                                : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => controller.selectRole(
                                        UserRole.lawyer,
                                      ),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: state.role == UserRole.lawyer
                                              ? Colors.white
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow:
                                              state.role == UserRole.lawyer
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.05),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                              : [],
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          l10n.lawyer,
                                          style: GoogleFonts.sora(
                                            fontSize: 14,
                                            fontWeight:
                                                state.role == UserRole.lawyer
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            color: state.role == UserRole.lawyer
                                                ? AppColors.primary
                                                : AppColors.textSecondaryLight,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Primary Action
                            GradientButton(
                              text: isLogin ? l10n.login : l10n.signup,
                              onPressed: () {
                                context.go(
                                  state.role == UserRole.client
                                      ? '/client'
                                      : '/lawyer',
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // Toggle Login / Signup
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLogin
                                      ? "Don't have an account? "
                                      : "Already have an account? ",
                                  style: const TextStyle(
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.toggleMode,
                                  child: Text(
                                    isLogin ? l10n.signup : l10n.login,
                                    style: GoogleFonts.sora(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
