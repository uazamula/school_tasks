import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class MemoryPair {
  const MemoryPair({
    this.id,
    required this.hiddenContent,
    required this.faceFront,
    this.faceBack,
  });

  /// Ідентифікатор пари. Якщо null — пул присвоює його за індексом.
  final String? id;

  /// Картка B: прихований вміст (картинка або слово).
  final TaskContent hiddenContent;

  /// Картка A: видима сторона.
  final TaskContent faceFront;

  /// Картка A: зворотний бік. null — картка A не перевертається.
  final TaskContent? faceBack;

  MemoryPair withId(String newId) => MemoryPair(
    id: newId,
    hiddenContent: hiddenContent,
    faceFront: faceFront,
    faceBack: faceBack,
  );

  /// Єдине ефективне аудіо: B затіняє A-front, A-front затіняє A-back.
  AudioContent? get effectiveAudio =>
      _audioOf(hiddenContent) ??
      _audioOf(faceFront) ??
      (faceBack == null ? null : _audioOf(faceBack!));

  int get audioCount => [hiddenContent, faceFront, faceBack].where((c) {
    return c != null && _audioOf(c) != null;
  }).length;

  static AudioContent? _audioOf(TaskContent content) =>
      content is AudioContent ? content : content.audio;

  /// Попередження для авторів контенту: аудіо більше ніж в одній половині.
  void debugWarnIfAmbiguousAudio() {
    if (audioCount > 1) {
      debugPrint(
        'MemoryPair($id): audio in more than one card; '
        'only the first (B > A front > A back) will play.',
      );
    }
  }
}
