import 'package:flutter/material.dart';
import 'package:school_tasks/core/preferences/preference_values.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'preference_keys.dart';

class AppPreferences {
  AppPreferences(this._prefs);

  final SharedPreferences _prefs;

  ThemeMode getThemeMode() {
    final value = _prefs.getString(PreferenceKeys.themeMode);

    switch (value) {
      case PreferenceValues.light:
        return ThemeMode.light;

      case PreferenceValues.dark:
        return ThemeMode.dark;

      default:
        return ThemeMode.system;
    }
  }

  Future<bool> setThemeMode(ThemeMode mode) {
    return _prefs.setString(PreferenceKeys.themeMode, switch (mode) {
      ThemeMode.light => PreferenceValues.light,
      ThemeMode.dark => PreferenceValues.dark,
      ThemeMode.system => PreferenceValues.system,
    });
  }

  Locale getLocale() {
    final languageCode = _prefs.getString(PreferenceKeys.languageCode);

    if (languageCode == null) {
      return const Locale(PreferenceValues.uk);
    }

    return Locale(languageCode);
  }

  Future<bool> setLocale(Locale locale) {
    return _prefs.setString(PreferenceKeys.languageCode, locale.languageCode);
  }
}
