import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/task_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';

abstract class LearningTask<TAnswer, TSolution> {
  const LearningTask({
    required this.prompt,
    required this.interaction,
    required this.solution,
  });

  final TaskPrompt prompt;
  final TaskInteraction interaction;
  final Solution<TAnswer, TSolution> solution;

  TaskResult<TAnswer, TSolution> checkAnswer(TAnswer answer);
}
