import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/input_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';

class InputTask extends LearningTask<Rational, Rational> {
  InputTask({
    required super.prompt,
    required super.solution,
    required InputMode inputMode,
  }) : super(interaction: InputInteraction(inputMode: inputMode));

  InputMode get inputMode => (interaction as InputInteraction).inputMode;

  @override
  TaskResult<Rational, Rational> checkAnswer(Rational userAnswer) {
    final isCorrect = solution.evaluate(userAnswer);

    return TaskResult<Rational, Rational>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: userAnswer,
      solution: solution,
    );
  }
}
