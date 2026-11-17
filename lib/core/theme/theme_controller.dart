import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:school_tasks/core/theme/theme_app_theme_choice.dart';

import '../preferences/preferences_provider.dart';

// dart run build_runner build - у терміналі
part 'theme_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeController extends _$ThemeController {
  @override
  Future<AppThemeChoice> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getThemeChoice();
  }

  Future<void> setThemeChoice(AppThemeChoice choice) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setThemeChoice(choice);

    state = AsyncData(choice);
  }
}
