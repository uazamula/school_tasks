import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';

// dart run build_runner build - у терміналі
part 'kids_ui_controller.g.dart';

/// Стан дитячого інтерфейсу: true — увімкнено.
@Riverpod(keepAlive: true)
class KidsUiController extends _$KidsUiController {
  @override
  Future<bool> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    return preferences.getKidsUiEnabled();
  }

  Future<void> setEnabled(bool enabled) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setKidsUiEnabled(enabled);

    state = AsyncData(enabled);
  }
}
