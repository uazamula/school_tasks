import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class AudioLinkedContent extends TaskContent {
  const AudioLinkedContent({required this.content, required this.audio});

  final TaskContent content;
  final AudioContent audio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioLinkedContent &&
          other.content == content &&
          other.audio == audio;

  @override
  int get hashCode => Object.hash(content, audio);
}
