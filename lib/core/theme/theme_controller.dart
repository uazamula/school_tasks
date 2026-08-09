import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../preferences/preferences_provider.dart';
// dart run build_runner build - у терміналі
part 'theme_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  @override
  Future<ThemeMode> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setThemeMode(mode);

    state = AsyncData(mode);
  }
}
