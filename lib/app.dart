import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/l10n/app_localizations.dart';

import 'core/localization/locale_controller.dart';
import 'core/statistics/usage_statistics_service_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(usageStatisticsServiceProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: locale.value,

      routerConfig: appRouter,

      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode.value ?? ThemeMode.system,
    );
  }
}
