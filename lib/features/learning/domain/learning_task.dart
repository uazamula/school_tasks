import 'task_interaction.dart';
import 'task_prompt.dart';
import 'task_result.dart';

abstract class LearningTask<TAnswer> {
  const LearningTask({required this.prompt, required this.interaction});

  final TaskPrompt prompt;
  final TaskInteraction interaction;

  TaskResult<TAnswer> checkAnswer(TAnswer answer);
}
