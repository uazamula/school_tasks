import 'dart:math';

import 'package:school_tasks/features/learning/data/generation/task_data_generator.dart';
import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_data/position_selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/content_grid.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_mode.dart';

/// Генератор завдань «знайди ціль у сітці».
///
/// Ціль і відволікаючі елементи задаються у конфігурації, тому підходить
/// і для емодзі, і для літер. Нумерація позицій з 1, як у [GridPosition].
///
/// Приклад «знайди всі яблука»:
/// ```dart
/// GridFindTaskDataGenerator(
///   taskCount: 5,
///   rows: 4,
///   columns: 5,
///   target: const EmojiContent('🍎'),
///   distractors: GridFindTaskDataGenerator.emojis(['🍌', '🍊', '🍐']),
///   minTargets: 3,
///   maxTargets: 6,
/// )
/// ```
///
/// Приклад «знайди літеру М» (одна):
/// ```dart
/// GridFindTaskDataGenerator(
///   taskCount: 5,
///   rows: 3,
///   columns: 4,
///   target: const TextContent('М'),
///   distractors: GridFindTaskDataGenerator.letters(['Н', 'П', 'Л']),
///   selectionMode: SelectionMode.single,
/// )
/// ```
class GridFindTaskDataGenerator extends TaskDataGenerator {
  GridFindTaskDataGenerator({
    required this.taskCount,
    required this.rows,
    required this.columns,
    required this.target,
    required List<TaskContent> distractors,
    this.selectionMode = SelectionMode.multiple,
    this.minTargets = 1,
    int? maxTargets,
    this.requiresConfirmation = false,
    this.promptText,
    this.targetFontSize,
    Random? random,
  }) : distractors = List.unmodifiable(distractors),
        maxTargets = maxTargets ?? minTargets,
        _random = random ?? Random() {
    _validate();
  }

  /// Допоміжні списки: рядок символів або список рядків у контент.
  static List<TaskContent> emojis(Iterable<String> items) => [
    for (final item in items) EmojiContent(item),
  ];

  static List<TaskContent> letters(Iterable<String> items) => [
    for (final item in items) TextContent(item),
  ];

  final Random _random;

  final int taskCount;
  final int rows;
  final int columns;

  /// Що треба знайти.
  final TaskContent target;

  /// Пул відволікаючих елементів (вибираються випадково з повтореннями).
  final List<TaskContent> distractors;

  final SelectionMode selectionMode;

  /// Скільки разів ціль зустрічається в сітці: від [minTargets] до [maxTargets].
  final int minTargets;
  final int maxTargets;

  /// Підтвердження для режиму single (для multiple воно завжди є).
  final bool requiresConfirmation;

  /// Текст умови. null — стандартний залежно від режиму.
  final String? promptText;

  /// Розмір шрифта цілі в умові (якщо ціль — текст).
  final double? targetFontSize;

  void _validate() {
    if (taskCount < 1) {
      throw ArgumentError.value(taskCount, 'taskCount', 'Must be at least 1.');
    }

    if (rows < 1 || columns < 1) {
      throw ArgumentError('rows and columns must be at least 1.');
    }

    if (minTargets < 1 || maxTargets < minTargets) {
      throw ArgumentError(
        'Invalid targets range: $minTargets..$maxTargets.',
      );
    }

    if (maxTargets >= rows * columns) {
      throw ArgumentError(
        'maxTargets ($maxTargets) must be less than the cell count '
            '(${rows * columns}), otherwise there are no distractors.',
      );
    }

    if (distractors.isEmpty) {
      throw ArgumentError('distractors must not be empty.');
    }

    if (distractors.contains(target)) {
      throw ArgumentError('distractors must not contain the target.');
    }
  }

  @override
  List<TaskData> generate() {
    return List<PositionSelectionTaskData>.generate(
      taskCount,
          (_) => _createTask(),
    );
  }

  PositionSelectionTaskData _createTask() {
    final total = rows * columns;
    final count = minTargets + _random.nextInt(maxTargets - minTargets + 1);

    // Позиції цілей: перші [count] індексів перемішаного списку.
    final targetIndices = (List<int>.generate(total, (i) => i)
      ..shuffle(_random)).take(count).toSet();

    final cells = [
      for (var row = 0; row < rows; row++)
        [
          for (var column = 0; column < columns; column++)
            targetIndices.contains(row * columns + column)
                ? target
                : distractors[_random.nextInt(distractors.length)],
        ],
    ];

    final correctPositions = [
      for (final index in targetIndices.toList()..sort())
        GridPosition(row: index ~/ columns + 1, column: index % columns + 1),
    ];

    return PositionSelectionTaskData(
      prompt: TaskPrompt(
        content: [TextContent(promptText ?? _defaultPromptText(count))],
        target: TargetContent(target: target, fontSize: targetFontSize),
      ),
      grid: ContentGrid(cells),
      correctPositions: correctPositions,
      selectionMode: selectionMode,
      requiresConfirmation: requiresConfirmation,
    );
  }

  String _defaultPromptText(int targetCount) {
    if (selectionMode == SelectionMode.multiple) {
      return 'Знайди всі';
    }

    return targetCount > 1 ? 'Знайди будь-який' : 'Знайди';
  }
}