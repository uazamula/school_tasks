import 'learning_task.dart';
import 'numeric_input_interaction.dart';
import 'task_answer_state.dart';
import 'task_result.dart';

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
