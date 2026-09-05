import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_data/position_selection_task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/emoji_grid.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';

final positionSelectionTasks = <PositionSelectionTaskData>[
  PositionSelectionTaskData(
    prompt: TaskPrompt(
      content: [
        TextContent('Вибери будь-яке яблуко у другому справа стовпчику.'),
      ],
    ),
    grid: EmojiGrid([
      '🍌🍎🍎🍌🍎',
      '🍎🍎🍎🍎🍎',
      '🍎🍎🍎🍎🍎',
      '🍌🍌🍌🍌🍌',
    ]).content,
    correctPositions: [
      GridPosition(row: 2, column: 4),
      GridPosition(row: 3, column: 4),
    ],
    selectionMode: SelectionMode.single,
  ),

  PositionSelectionTaskData(
    prompt: TaskPrompt(
      content: [TextContent('Вибери всі яблука у четвертому стовпчику.')],
    ),
    grid: EmojiGrid([
      '🍌🍎🍎🍌🍎',
      '🍎🍎🍎🍎🍎',
      '🍎🍎🍎🍎🍎',
      '🍌🍌🍌🍌🍌',
    ]).content,
    correctPositions: [
      GridPosition(row: 2, column: 4),
      GridPosition(row: 3, column: 4),
    ],
    selectionMode: SelectionMode.multiple,
  ),
];
