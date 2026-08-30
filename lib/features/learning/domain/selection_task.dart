import 'learning_task.dart';
import 'selection_interaction.dart';
import 'task_answer_state.dart';
import 'task_result.dart';

class SelectionTask<TOption, TAnswer, TSolution>
    extends LearningTask<TAnswer, TSolution> {
  SelectionTask({
    required super.prompt,
    required super.solution,
    required this.options,
    required SelectionMode mode,
  }) : super(interaction: SelectionInteraction(mode: mode));

  final List<TOption> options;

  @override
  TaskResult<TAnswer, TSolution> checkAnswer(TAnswer answer) {
    final isCorrect = solution.evaluate(answer);

    return TaskResult<TAnswer, TSolution>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}
