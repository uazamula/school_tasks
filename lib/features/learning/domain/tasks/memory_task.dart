import 'package:school_tasks/features/learning/domain/task_data/memory_task_config.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/memory_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/memory_board_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/progress_reporting_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/memory_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class MemoryTask extends LearningTask<MemoryAnswer, List<MemoryPair>>
    with ProgressReportingTask {
  MemoryTask({
    required super.prompt,
    required List<MemoryPair> pairs,
    required this.config,
    this.boardSource,
    this.targetStreak,
    this.continueAfterGoal = false,
  }) : assert(targetStreak == null || boardSource != null),
       super(
         interaction: const MemoryInteraction(),
         solution: Solution<MemoryAnswer, List<MemoryPair>>(
           value: List.unmodifiable(pairs),
           evaluator: const MemoryEvaluator(),
         ),
       ) {
    _validate(pairs);
  }

  final int? targetStreak;
  final bool continueAfterGoal;

  /// Нескінченне завдання не має фіксованої кількості кроків.
  @override
  int get progressSteps => isEndless ? (targetStreak ?? 0) : pairs.length;

  final MemoryTaskConfig config;

  /// Не null — нескінченний режим.
  final MemoryBoardSource? boardSource;

  bool get isEndless => boardSource != null;

  /// Скінченний: пари дошки. Нескінченний: увесь пул.
  List<MemoryPair> get pairs => solution.value;

  void _validate(List<MemoryPair> pairs) {
    final ids = <String>{};

    for (final pair in pairs) {
      final id = pair.id;

      if (id == null || !ids.add(id)) {
        throw ArgumentError('MemoryPair ids must be set and unique: $id');
      }

      pair.debugWarnIfAmbiguousAudio();
    }

    if (!isEndless && pairs.length != config.gridSize.pairCount) {
      throw ArgumentError(
        'Finite board needs ${config.gridSize.pairCount} pairs, '
        'got ${pairs.length}.',
      );
    }
  }

  @override
  TaskResult<MemoryAnswer, List<MemoryPair>> checkAnswer(MemoryAnswer answer) {
    final isCorrect = solution.evaluate(answer);

    return TaskResult<MemoryAnswer, List<MemoryPair>>(
      state: isCorrect ? TaskAnswerState.correct : TaskAnswerState.incorrect,
      selectedAnswer: answer,
      solution: solution,
    );
  }
}
