import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/any_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/set_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class PositionSelectionTask
    extends LearningTask<List<GridPosition>, List<GridPosition>> {
  PositionSelectionTask({
    required super.prompt,
    required this.grid,
    required List<GridPosition> correctPositions,
    required SelectionMode mode,
  }) : _correctPositions = correctPositions,
       super(
         interaction: SelectionInteraction(mode: mode),
         solution: Solution<List<GridPosition>, List<GridPosition>>(
           value: correctPositions,
           evaluator: mode == SelectionMode.single
               ? const AnyEqualsEvaluator<GridPosition>()
               : const SetEqualsEvaluator<GridPosition>(),
         ),
       );

  final List<List<TaskContent>> grid;
  final List<GridPosition> _correctPositions;

  List<GridPosition> get correctPositions =>
      List.unmodifiable(_correctPositions);

  SelectionMode get mode => (interaction as SelectionInteraction).mode;

  @override
  TaskResult<List<GridPosition>, List<GridPosition>> checkAnswer(
    List<GridPosition> answer,
  ) {
    final isCorrect = solution.evaluate(answer);

    return TaskResult<List<GridPosition>, List<GridPosition>>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}
