import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_mode.dart';

class PositionSelectionTaskData extends TaskData {
  const PositionSelectionTaskData({
    required super.prompt,
    required this.grid,
    required this.correctPositions,
    required this.selectionMode,
    this.requiresConfirmation = false,
  });

  final List<List<TaskContent>> grid;
  final List<GridPosition> correctPositions;
  final SelectionMode selectionMode;
  final bool requiresConfirmation;
}
