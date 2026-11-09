import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/predefined_answer_selector.dart';
import 'package:school_tasks/features/learning/data/generation/weighted_memory_board_source.dart';
import 'package:school_tasks/features/learning/domain/attempts/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt.dart';
import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/fraction_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/matching_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_board_mode.dart';
import 'package:school_tasks/features/learning/domain/task_data/memory_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/position_selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/slot_assembly_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_pool.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/fraction_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/memory_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/position_selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/approximate_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/set_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/tolerance_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_order_mode.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';

class TopicAttemptGenerator {
  TopicAttemptGenerator({
    Random? random,
    PredefinedAnswerSelector? answerSelector,
  }) : _random = random ?? Random(),
       _answerSelector = answerSelector ?? const PredefinedAnswerSelector();

  final Random _random;
  final PredefinedAnswerSelector _answerSelector;

  // Реєстр типів завдань: один рядок на тип замість окремого пулу,
  // гілки switch і гілки if.
  late final _TaskFactory _memory = _TypedTaskFactory<MemoryTaskData>(
    _createMemoryTask,
  );

  late final _TaskFactory _selection =
      _TypedTaskFactory<SelectionTaskData<dynamic>>(_createSelectionTask);

  late final _TaskFactory _input = _TypedTaskFactory<InputTaskData>(
    (data) => AttemptTask<Rational, Rational>(task: _createInputTask(data)),
  );

  late final _TaskFactory _fraction = _TypedTaskFactory<FractionTaskData>(
    _createFractionTask,
  );

  late final _TaskFactory _positionSelection =
      _TypedTaskFactory<PositionSelectionTaskData>(
        _createPositionSelectionTask,
      );

  late final _TaskFactory _matching = _TypedTaskFactory<MatchingTaskData>(
    _createMatchingTask,
  );

  late final _TaskFactory _slotAssembly =
      _TypedTaskFactory<SlotAssemblyTaskData<dynamic>>(_createSlotAssemblyTask);

  /// Усі фабрики — для режиму, де тип завдання визначають самі дані.
  late final List<_TaskFactory> _allFactories = [
    _selection,
    _input,
    _fraction,
    _positionSelection,
    _matching,
    _slotAssembly,
    _memory,
  ];

  _TaskFactory _factoryFor(LearningTaskType type) {
    switch (type) {
      case LearningTaskType.selection:
        return _selection;
      case LearningTaskType.input:
        return _input;
      case LearningTaskType.fraction:
        return _fraction;
      case LearningTaskType.positionSelection:
        return _positionSelection;
      case LearningTaskType.matching:
        return _matching;
      case LearningTaskType.slotAssembly:
        return _slotAssembly;
      case LearningTaskType.memory:
        return _memory;
    }
  }

  TopicAttempt generate(Topic topic) {
    if (topic.taskOrderMode == TaskOrderMode.deterministic) {
      final data = topic.dataSource.getData();
      final tasks = data.map(_createTaskFromData).toList();
      return TopicAttempt(tasks: _arrangeEndlessLast(topic, tasks));
    }

    final taskTypes = <LearningTaskType>[];

    for (final entry in topic.taskTypeCounts.entries) {
      taskTypes.addAll(List.filled(entry.value, entry.key));
    }

    taskTypes.shuffle(_random);

    final data = topic.dataSource.getData();

    // Пул даних створюється один раз на тип, щоб завдання одного типу
    // не повторювали дані, доки пул не вичерпається.
    final suppliers =
        <LearningTaskType, AttemptTask<dynamic, dynamic> Function()>{};

    final tasks = taskTypes.map((type) {
      final supplier = suppliers.putIfAbsent(
        type,
        () => _factoryFor(type).randomSupplier(data, _random),
      );

      return supplier();
    }).toList();

    return TopicAttempt(tasks: _arrangeEndlessLast(topic, tasks));
  }

  List<AttemptTask<dynamic, dynamic>> _arrangeEndlessLast(
    Topic topic,
    List<AttemptTask<dynamic, dynamic>> tasks,
  ) {
    final endless = tasks.where((t) {
      final task = t.task;
      return task is MemoryTask && task.isEndless;
    }).toList();

    if (endless.isEmpty) return tasks;

    if (endless.length > 1) {
      throw StateError('A topic can contain at most one endless memory task.');
    }
    final memory = endless.single.task as MemoryTask;
    final hasGoal = memory.targetStreak != null;

    if (hasGoal != (topic.resultKind == TopicResultKind.grade)) {
      throw StateError(
        'Endless memory with a goal needs resultKind grade; '
        'without a goal it needs resultKind streak.',
      );
    }

    if (hasGoal && topic.evaluation.weights.isEmpty) {
      throw StateError('Endless memory with a goal needs evaluation weights.');
    }
    final termination = topic.automaticTermination;
    if (termination?.failureLimit == null && termination?.countdown == null) {
      throw StateError(
        'Endless memory needs automaticTermination.failureLimit or countdown.',
      );
    }

    if (topic.progressionMode == TopicProgressionMode.manual) {
      throw StateError('Endless memory does not support manual progression.');
    }

    return [
      ...tasks.where((t) => !identical(t, endless.single)),
      endless.single,
    ];
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
          buttonConfig: data.buttonConfig,
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
        buttonConfig: data.buttonConfig,
      ),
    );
  }

  InputTask _createInputTask(InputTaskData data) {
    final evaluator = _createInputEvaluator(data.tolerance);

    return InputTask(
      prompt: data.prompt,
      solution: Solution<Rational, Rational>(
        value: data.correctAnswer,
        evaluator: evaluator,
      ),
      inputMode: data.inputMode,
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
      task: MatchingTask(
        prompt: data.prompt,
        pairs: pairs,
        buttonConfig: data.buttonConfig,
      ),
    );
  }

  AttemptTask<List<dynamic>, List<dynamic>> _createSlotAssemblyTask(
    SlotAssemblyTaskData<dynamic> data,
  ) {
    final correctAnswers = data.correctAnswers;

    final wrongAnswers = _answerSelector.select(
      items: data.wrongAnswers,
      count: data.wrongAnswerCount,
      random: _random,
    );

    final options = [...correctAnswers, ...wrongAnswers]..shuffle(_random);

    return AttemptTask<List<dynamic>, List<dynamic>>(
      task: SlotAssemblyTask<dynamic>(
        prompt: data.prompt,
        correctAnswers: correctAnswers,
        options: options,
        requiresSequentialSelection: data.requiresSequentialSelection,
        uiConfig: data.uiConfig,
        interactionMode: data.interactionMode,
      ),
    );
  }

  AttemptTask<MemoryAnswer, List<MemoryPair>> _createMemoryTask(
    MemoryTaskData data,
  ) {
    final pool = data.normalizedPool;
    final pairCount = data.config.gridSize.pairCount;

    switch (data.mode) {
      case FiniteMemoryMode():
        final pairs = _answerSelector.select(
          items: pool,
          count: pairCount,
          random: _random,
        );

        return AttemptTask<MemoryAnswer, List<MemoryPair>>(
          task: MemoryTask(
            prompt: data.prompt,
            pairs: pairs,
            config: data.config,
          ),
        );

      case EndlessMemoryMode(
        :final failedPairWeight,
        :final targetStreak,
        :final continueAfterGoal,
      ):
        return AttemptTask<MemoryAnswer, List<MemoryPair>>(
          task: MemoryTask(
            prompt: data.prompt,
            pairs: pool,
            config: data.config,
            targetStreak: targetStreak,
            continueAfterGoal: continueAfterGoal,
            boardSource: WeightedMemoryBoardSource(
              pool: pool,
              pairsPerBoard: pairCount,
              failedPairWeight: failedPairWeight,
              random: _random,
            ),
          ),
        );
    }
  }

  SolutionEvaluator<Rational, Rational> _createInputEvaluator(
    ToleranceConfig tolerance,
  ) {
    switch (tolerance) {
      case ExactToleranceConfig():
        return const EqualsEvaluator<Rational>();

      case ApproximateToleranceConfig(
        :final relativeTolerance,
        :final absoluteTolerance,
      ):
        return ApproximateEqualsEvaluator(
          relativeTolerance: relativeTolerance,
          absoluteTolerance: absoluteTolerance,
        );
    }
    throw StateError('Unsupported ToleranceConfig: ${tolerance.runtimeType}');
  }

  AttemptTask<dynamic, dynamic> _createTaskFromData(TaskData data) {
    for (final factory in _allFactories) {
      if (factory.accepts(data)) {
        return factory.create(data);
      }
    }

    throw StateError('Unsupported task data type: ${data.runtimeType}');
  }
}

/// Створює завдання певного типу з даних цього типу.
abstract class _TaskFactory {
  bool accepts(TaskData data);

  AttemptTask<dynamic, dynamic> create(TaskData data);

  /// Повертає функцію, що щоразу бере випадкові дані з пулу й створює завдання.
  AttemptTask<dynamic, dynamic> Function() randomSupplier(
    List<TaskData> data,
    Random random,
  );
}

class _TypedTaskFactory<T extends TaskData> implements _TaskFactory {
  const _TypedTaskFactory(this._build);

  final AttemptTask<dynamic, dynamic> Function(T data) _build;

  @override
  bool accepts(TaskData data) => data is T;

  @override
  AttemptTask<dynamic, dynamic> create(TaskData data) => _build(data as T);

  @override
  AttemptTask<dynamic, dynamic> Function() randomSupplier(
    List<TaskData> data,
    Random random,
  ) {
    final pool = TaskDataPool<T>(
      items: data.whereType<T>().toList(),
      random: random,
    );

    return () => _build(pool.takeRandom());
  }
}
