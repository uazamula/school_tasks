import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'routing/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,

      theme: AppTheme.light(),

      // Поки що darkTheme така сама.
      // На наступному кроці зробимо справжню темну тему.
      darkTheme: AppTheme.dark(),

      themeMode: themeMode.value ?? ThemeMode.system,
    );
  }
}
