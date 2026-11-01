import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

/// Аудіо варіантів SlotAssembly: контролери відтворення за індексом
/// варіанта та очікування останнього відтворення перед завершенням завдання.
class SlotAssemblyAudio {
  final Map<int, AudioPlaybackController> _controllers = {};
  Future<void>? _pendingPlayback;

  /// Аудіо варіанта: кожен вид контенту може мати власне аудіо.
  static AudioContent? audioFor(Object? option) {
    if (option is AudioContent) return option;
    if (option is TaskContent) return option.audio;
    return null;
  }

  /// Контролер варіанта (створюється при першому зверненні).
  AudioPlaybackController controllerFor(int index) {
    return _controllers.putIfAbsent(index, AudioPlaybackController.new);
  }

  /// Перемикає відтворення варіанта (старт/стоп).
  void toggle(int index) => _controllers[index]?.toggle();

  /// Запускає відтворення варіанта й запамʼятовує його,
  /// щоб завершення завдання дочекалося кінця звуку.
  void play(int index, Object? option) {
    if (audioFor(option) == null) return;

    final playback = _controllers[index]?.playAndWait();

    if (playback != null) {
      _pendingPlayback = playback;
    }
  }

  /// Повертає й скидає очікуване відтворення.
  Future<void>? takePendingPlayback() {
    final playback = _pendingPlayback;
    _pendingPlayback = null;
    return playback;
  }

  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
    _pendingPlayback = null;
  }
}
