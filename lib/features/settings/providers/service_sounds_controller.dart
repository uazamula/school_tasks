import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/core/services/audio/audio_service_provider.dart';

part 'service_sounds_controller.g.dart';

@Riverpod(keepAlive: true)
class ServiceSoundsController extends _$ServiceSoundsController {
  @override
  Future<bool> build() async {
    final preferences = await ref.watch(appPreferencesProvider.future);

    final enabled = preferences.getServiceSoundsEnabled();

    // Синхронізуємо AudioService зі збереженим налаштуванням.
    ref.read(audioServiceProvider).setEnabled(enabled);

    return enabled;
  }

  Future<void> setEnabled(bool enabled) async {
    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setServiceSoundsEnabled(enabled);

    // Змінюємо стан спільного AudioService.
    ref.read(audioServiceProvider).setEnabled(enabled);

    state = AsyncData(enabled);
  }
}
