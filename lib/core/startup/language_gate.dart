import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/config/app_config.dart';
import 'package:school_tasks/core/localization/locale_controller.dart';
import 'package:school_tasks/core/theme/app_colors.dart';
import 'package:school_tasks/core/widgets/language_flag.dart';
import 'package:school_tasks/l10n/app_localizations.dart';

/// Показує вибір мови, поки користувач її не обрав.
/// Якщо підтримується лише одна мова, екран не з'являється.
class LanguageGate extends ConsumerWidget {
  const LanguageGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeControllerProvider);
    final needsChoice = locale.hasValue && locale.value == null;
    final languages = AppLocalizations.supportedLocales;

    return Stack(
      children: [
        child,
        if (needsChoice && languages.length > 1)
          Positioned.fill(
            child: Material(
              color: const Color(0xFFFFF8EE),
              child: SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.language,
                          size: 96,
                          color: AppColors.gentleSeed,
                        ),
                        const SizedBox(height: 32),
                        for (final language in languages) ...[
                          SizedBox(
                            width: 280,
                            height: 72,
                            child: FilledButton(
                              onPressed: () => ref
                                  .read(localeControllerProvider.notifier)
                                  .setLocale(Locale(language.languageCode)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  LanguageFlag(
                                    languageCode: language.languageCode,
                                    height: 36,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    AppConfig.languageNames[language
                                            .languageCode] ??
                                        language.languageCode,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
