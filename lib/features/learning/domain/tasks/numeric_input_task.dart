import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/numeric_input_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';

class NumericInputTask extends LearningTask<int, int> {
  const NumericInputTask({required super.prompt, required super.solution})
    : super(interaction: const NumericInputInteraction());

  @override
  TaskResult<int, int> checkAnswer(int answer) {
    final isCorrect = answer == solution.value;

    return TaskResult<int, int>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}
