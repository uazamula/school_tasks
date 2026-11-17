import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/services/emoji_preloader.dart';
import 'package:school_tasks/core/theme/theme_app_theme_choice.dart';
import 'package:school_tasks/l10n/app_localizations.dart';

import 'core/localization/locale_controller.dart';
import 'core/statistics/usage_statistics_service_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/settings/providers/service_sounds_controller.dart';
import 'routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(usageStatisticsServiceProvider);
    ref.watch(serviceSoundsControllerProvider);

    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    final themeChoice =
        ref.watch(themeControllerProvider).value ?? AppThemeChoice.system;
    final isGentle = themeChoice == AppThemeChoice.gentle;

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeAnimationDuration: Duration.zero,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: locale.value,

      routerConfig: appRouter,

      theme: isGentle ? AppTheme.gentle() : AppTheme.light(),
      // Для «лагідної» темна тема теж лагідна, щоб тема пристрою не впливала.
      darkTheme: isGentle ? AppTheme.gentle() : AppTheme.dark(),
      themeMode: themeChoice.themeMode,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);

        // Для «лагідної» теми текст трохи крупніший, з урахуванням
        // системного масштабу шрифту.
        final textScaler = isGentle
            ? TextScaler.linear(mediaQuery.textScaler.scale(1) * 1.15)
            : mediaQuery.textScaler;

        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: textScaler),
          child: ColoredBox(
            color: Theme.of(context).colorScheme.surface,
            child: EmojiPreloader(child: child ?? const SizedBox.shrink()),
          ),
        );
      },
    );
  }
}
