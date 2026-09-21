import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/input_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';

class InputTask extends LearningTask<int, int> {
  InputTask({
    required super.prompt,
    required super.solution,
    required InputMode inputMode,
  }) : super(interaction: InputInteraction(inputMode: inputMode));

  InputMode get inputMode => (interaction as InputInteraction).inputMode;

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
