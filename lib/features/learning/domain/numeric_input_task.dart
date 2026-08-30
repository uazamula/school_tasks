import 'learning_task.dart';
import 'numeric_input_interaction.dart';
import 'task_answer_state.dart';
import 'task_result.dart';

class NumericInputTask extends LearningTask<int> {
  const NumericInputTask({required super.prompt, required this.correctAnswer})
    : super(interaction: const NumericInputInteraction());

  final int correctAnswer;

  @override
  TaskResult<int> checkAnswer(int answer) {
    return TaskResult<int>(
      state: answer == correctAnswer
          ? TaskAnswerState.correct
          : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      correctAnswer: correctAnswer,
    );
  }
}
