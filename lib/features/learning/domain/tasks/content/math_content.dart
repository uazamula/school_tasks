import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';

class MathContent extends TaskContent {
  const MathContent(this.expression, {this.audio});

  final String expression;
  final AudioContent? audio;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MathContent &&
          other.expression == expression &&
          other.audio == audio;

  @override
  int get hashCode => Object.hash(expression, audio);
}
