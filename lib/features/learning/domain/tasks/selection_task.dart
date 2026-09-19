import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';

class SelectionTask<TOption, TAnswer, TSolution>
    extends LearningTask<TAnswer, TSolution> {
  SelectionTask({
    required super.prompt,
    required super.solution,
    required this.options,
    required bool isMultiple,
    required bool requiresConfirmation,
  }) : super(
         interaction: SelectionInteraction(
           isMultiple: isMultiple,
           requiresConfirmation: isMultiple || requiresConfirmation,
         ),
       );

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
