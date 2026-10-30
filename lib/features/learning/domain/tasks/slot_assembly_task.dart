import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_ui_config.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class SlotAssemblyTask<TOption>
    extends LearningTask<List<TOption>, List<TOption>> {
  SlotAssemblyTask({
    required super.prompt,
    required List<TOption> correctAnswers,
    required this.options,
    required bool requiresSequentialSelection,
    this.uiConfig = const SlotAssemblyUiConfig(),
    SlotAssemblyInteractionMode interactionMode =
        const PressForSlotInteractionMode(),
  }) : super(
         interaction: SlotAssemblyInteraction(
           requiresSequentialSelection: requiresSequentialSelection,
           mode: interactionMode,
         ),
         solution: Solution<List<TOption>, List<TOption>>(
           value: List.unmodifiable(correctAnswers),
           evaluator: SlotAssemblySolutionEvaluator<TOption>(),
         ),
       ) {
    if (correctAnswers.isEmpty) {
      throw ArgumentError('correctAnswers must not be empty.');
    }
  }

  /// Варіанти, доступні для вибору.
  final List<TOption> options;

  /// Правильні елементи в порядку слотів.
  List<TOption> get correctAnswers => solution.value;

  final SlotAssemblyUiConfig uiConfig;

  @override
  TaskResult<List<TOption>, List<TOption>> checkAnswer(List<TOption> answer) {
    final isCorrect = solution.evaluate(answer);

    return TaskResult<List<TOption>, List<TOption>>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}

class SlotAssemblySolutionEvaluator<TOption>
    extends SolutionEvaluator<List<TOption>, List<TOption>> {
  const SlotAssemblySolutionEvaluator();

  @override
  bool evaluate(List<TOption> answer, List<TOption> solution) {
    if (answer.length != solution.length) {
      return false;
    }

    for (var i = 0; i < solution.length; i++) {
      if (answer[i] != solution[i]) {
        return false;
      }
    }

    return true;
  }
}
