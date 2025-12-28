import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../providers/language_provider.dart';
import 'package:flutter_application_1/providers/auth_ui_controller.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(authUiProvider);
    final controller = ref.read(authUiProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    final isLogin = state.mode == AuthMode.login;

    return Scaffold(
      appBar: AppBar(
        title: Text(isLogin ? l10n.login : l10n.signup),
        actions: const [LanguageSelector()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      l10n.welcomeMessage,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Email
                    TextField(
                      decoration: InputDecoration(
                        labelText: l10n.email,
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Full Name (Signup only)
                    if (!isLogin) ...[
                      TextField(
                        decoration: InputDecoration(
                          labelText: l10n.fullName,
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
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Role Selector (Signup only)
                    if (!isLogin) ...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.selectRole,
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<UserRole>(
                        segments: [
                          ButtonSegment(
                            value: UserRole.client,
                            label: Text(l10n.client),
                            icon: const Icon(Icons.person),
                          ),
                          ButtonSegment(
                            value: UserRole.lawyer,
                            label: Text(l10n.lawyer),
                            icon: const Icon(Icons.gavel),
                          ),
                        ],
                        selected: {state.role},
                        onSelectionChanged: (value) {
                          controller.selectRole(value.first);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // Primary Action
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      onPressed: () {
                        // Placeholder for real auth
                        context.go(
                          state.role == UserRole.client ? '/client' : '/lawyer',
                        );
                      },
                      child: Text(isLogin ? l10n.login : l10n.signup),
                    ),

                    const SizedBox(height: 12),

                    // Toggle Login / Signup
                    TextButton(
                      onPressed: controller.toggleMode,
                      child: Text(
                        isLogin
                            ? l10n.noAccountSignup
                            : l10n.alreadyHaveAccountLogin,
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
