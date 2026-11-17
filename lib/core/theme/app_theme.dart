import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
    );
  }

  /// Лагідна тема для дошкільнят: теплий фон, великі заокруглення,
  /// трохи крупніший текст. Завжди світла.
  static ThemeData gentle() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.gentleSeed,
      brightness: Brightness.light,
    ).copyWith(surface: AppColors.gentleSurface);

    final base = ThemeData(useMaterial3: true, colorScheme: colorScheme);

    return base.copyWith(
      scaffoldBackgroundColor: colorScheme.surface,
      // ... cardTheme, filledButtonTheme, elevatedButtonTheme без змін
    );
  }
}
