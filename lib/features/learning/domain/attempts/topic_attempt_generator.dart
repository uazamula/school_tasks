import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/predefined_answer_selector.dart';
import 'package:school_tasks/features/learning/domain/attempts/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt.dart';
import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_data/fraction_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/numeric_input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/position_selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_pool.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/fraction_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/position_selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/set_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

class TopicAttemptGenerator {
  TopicAttemptGenerator({
    Random? random,
    PredefinedAnswerSelector? answerSelector,
  }) : _random = random ?? Random(),
       _answerSelector = answerSelector ?? const PredefinedAnswerSelector();

  final Random _random;
  final PredefinedAnswerSelector _answerSelector;

  TopicAttempt generate(Topic topic) {
    final taskTypes = <LearningTaskType>[];

    for (final entry in topic.taskTypeCounts.entries) {
      taskTypes.addAll(List.filled(entry.value, entry.key));
    }

    taskTypes.shuffle(_random);

    final data = topic.dataSource.getData();

    final selectionDataPool = TaskDataPool<SelectionTaskData<dynamic>>(
      items: data.whereType<SelectionTaskData<dynamic>>().toList(),
      random: _random,
    );

    final numericInputDataPool = TaskDataPool<NumericInputTaskData>(
      items: data.whereType<NumericInputTaskData>().toList(),
      random: _random,
    );

    final fractionDataPool = TaskDataPool<FractionTaskData>(
      items: data.whereType<FractionTaskData>().toList(),
      random: _random,
    );

    final positionSelectionDataPool = TaskDataPool<PositionSelectionTaskData>(
      items: data.whereType<PositionSelectionTaskData>().toList(),
      random: _random,
    );

    final matchingDataPool = TaskDataPool<MatchingTaskData>(
      items: data.whereType<MatchingTaskData>().toList(),
      random: _random,
    );

    final tasks = taskTypes.map((type) {
      switch (type) {
        case LearningTaskType.selection:
          return _createSelectionTask(selectionDataPool.takeRandom());

        case LearningTaskType.numericInput:
          return AttemptTask<int, int>(
            task: _createNumericInputTask(numericInputDataPool.takeRandom()),
          );
        case LearningTaskType.fraction:
          return _createFractionTask(fractionDataPool.takeRandom());

        case LearningTaskType.positionSelection:
          return _createPositionSelectionTask(
            positionSelectionDataPool.takeRandom(),
          );

        case LearningTaskType.matching:
          return _createMatchingTask(matchingDataPool.takeRandom());
      }
    }).toList();

    return TopicAttempt(tasks: tasks);
  }

  AttemptTask<dynamic, dynamic> _createSelectionTask(
    SelectionTaskData<dynamic> data,
  ) {
    final correctAnswers = _answerSelector.select(
      items: data.correctAnswers,
      count: data.correctAnswerCount,
      random: _random,
    );

    final wrongAnswers = _answerSelector.select(
      items: data.wrongAnswers,
      count: data.wrongAnswerCount,
      random: _random,
    );

    final options = [...correctAnswers, ...wrongAnswers]..shuffle(_random);

    final isMultiple = data.correctAnswerCount > 1;

    if (!isMultiple) {
      return AttemptTask<dynamic, dynamic>(
        task: SelectionTask<dynamic, dynamic, dynamic>(
          prompt: data.prompt,
          options: options,
          solution: Solution<dynamic, dynamic>(
            value: correctAnswers.single,
            evaluator: const EqualsEvaluator<dynamic>(),
          ),
          isMultiple: false,
          requiresConfirmation: data.requiresConfirmation,
        ),
      );
    }

    return AttemptTask<List<dynamic>, List<dynamic>>(
      task: SelectionTask<dynamic, List<dynamic>, List<dynamic>>(
        prompt: data.prompt,
        options: options,
        solution: Solution<List<dynamic>, List<dynamic>>(
          value: correctAnswers,
          evaluator: const SetEqualsEvaluator<dynamic>(),
        ),
        isMultiple: true,
        requiresConfirmation: false,
      ),
    );
  }

  NumericInputTask _createNumericInputTask(NumericInputTaskData data) {
    return NumericInputTask(
      prompt: data.prompt,
      solution: Solution<int, int>(
        value: data.correctAnswer,
        evaluator: const EqualsEvaluator<int>(),
      ),
    );
  }

  AttemptTask<Set<int>, int> _createFractionTask(FractionTaskData data) {
    return AttemptTask<Set<int>, int>(
      task: FractionTask(
        prompt: data.prompt,
        numerator: data.numerator,
        denominator: data.denominator,
        parts: data.parts,
      ),
    );
  }

  AttemptTask<List<GridPosition>, List<GridPosition>>
  _createPositionSelectionTask(PositionSelectionTaskData data) {
    return AttemptTask<List<GridPosition>, List<GridPosition>>(
      task: PositionSelectionTask(
        prompt: data.prompt,
        grid: data.grid,
        correctPositions: data.correctPositions,
        mode: data.selectionMode,
        requiresConfirmation: data.requiresConfirmation,
      ),
    );
  }

  AttemptTask<MatchingAnswer, List<MatchingPair>> _createMatchingTask(
    MatchingTaskData data,
  ) {
    final pairs = _answerSelector.select(
      items: data.pairs,
      count: data.pairCount,
      random: _random,
    );

    return AttemptTask<MatchingAnswer, List<MatchingPair>>(
      task: MatchingTask(prompt: data.prompt, pairs: pairs),
    );
  }
}
