import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ------------------------------
/// Locale State (Riverpod)
/// ------------------------------
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() => const Locale('en');

  void update(Locale locale) {
    if (state != locale) {
      state = locale;
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// ------------------------------
/// Language Model
/// ------------------------------
@immutable
class AppLanguage {
  final Locale locale;
  final String label;

  const AppLanguage(this.locale, this.label);
}

const supportedLanguages = <AppLanguage>[
  AppLanguage(Locale('en'), 'English'),
  AppLanguage(Locale('ta'), 'தமிழ் (Tamil)'),
  AppLanguage(Locale('hi'), 'हिन्दी (Hindi)'),
  AppLanguage(Locale('ml'), 'മലയാളം (Malayalam)'),
  AppLanguage(Locale('kn'), 'ಕನ್ನಡ (Kannada)'),
  AppLanguage(Locale('te'), 'తెలుగు (Telugu)'),
];

/// ------------------------------
/// Language Selector (Material 3)
/// ------------------------------
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return DropdownMenu<Locale>(
      initialSelection: currentLocale,
      label: const Text('Language'),
      onSelected: (locale) {
        if (locale != null) {
          ref.read(localeProvider.notifier).update(locale);
        }
      },
      dropdownMenuEntries: supportedLanguages
          .map(
            (lang) => DropdownMenuEntry<Locale>(
              value: lang.locale,
              label: lang.label,
            ),
          )
          .toList(),
    );
  }
}
