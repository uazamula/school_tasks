import 'package:flutter/material.dart';

/// Вибір теми користувачем. На відміну від [ThemeMode],
/// містить дитячу тему «лагідна».
enum AppThemeChoice {
  system,
  light,
  dark,
  gentle;

  /// Режим для MaterialApp. «Лагідна» завжди світла,
  /// тому темна тема пристрою на неї не впливає.
  ThemeMode get themeMode => switch (this) {
    AppThemeChoice.system => ThemeMode.system,
    AppThemeChoice.light => ThemeMode.light,
    AppThemeChoice.dark => ThemeMode.dark,
    AppThemeChoice.gentle => ThemeMode.light,
  };
}
