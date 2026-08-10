import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../preferences/preferences_provider.dart';
// dart run build_runner build - у терміналі і комітимо (лежить в unversioned)

part 'locale_controller.g.dart';

@Riverpod(keepAlive: true)
class LocaleController extends _$LocaleController {
  @override
  Future<Locale> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getLocale();
  }

  Future<void> setLocale(Locale locale) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setLocale(locale);

    state = AsyncData(locale);
  }
}
