import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/selection_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/position_selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class PositionSelectionTaskWidget extends StatefulWidget {
  const PositionSelectionTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final PositionSelectionTask task;
  final TaskResult<List<GridPosition>, List<GridPosition>>? result;
  final ValueChanged<TaskResult<List<GridPosition>, List<GridPosition>>>
  onTaskAnswered;

  @override
  State<PositionSelectionTaskWidget> createState() =>
      _PositionSelectionTaskWidgetState();
}

class _PositionSelectionTaskWidgetState
    extends State<PositionSelectionTaskWidget> {
  final List<GridPosition> _selectedPositions = [];

  SelectionInteraction get _interaction =>
      widget.task.interaction as SelectionInteraction;

  bool get _isMultiple => _interaction.isMultiple;

  bool get _requiresConfirmation => _interaction.requiresConfirmation;

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  @override
  void didUpdateWidget(covariant PositionSelectionTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _selectedPositions.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGrid(),
        if (_requiresConfirmation) ...[
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _isAnswered || _selectedPositions.isEmpty
                ? null
                : _confirmAnswer,
            child: const Text('Підтвердити'),
          ),
        ],
      ],
    );
  }

  Widget _buildGrid() {
    final rows = widget.task.grid.length;
    final columns = widget.task.grid.first.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.sizeOf(context);

        final maxHeight = screenSize.height * 0.45;
        final maxWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : screenSize.width;

        const spacing = 1.0;

        final horizontalSpacing = spacing * (columns - 1);
        final verticalSpacing = spacing * (rows - 1);

        final cellSize = (
          (maxWidth - horizontalSpacing) / columns,
          (maxHeight - verticalSpacing) / rows,
        );

        final size = cellSize.$1 < cellSize.$2 ? cellSize.$1 : cellSize.$2;

        final width = size * columns + horizontalSpacing;
        final height = size * rows + verticalSpacing;

        return SizedBox(
          width: width,
          height: height,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemCount: rows * columns,
            itemBuilder: (context, index) {
              final row = index ~/ columns;
              final column = index % columns;

              return _buildCell(
                GridPosition(row: row + 1, column: column + 1),
                widget.task.grid[row][column],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCell(GridPosition position, TaskContent content) {
    final isSelected = _selectedPositions.contains(position);
    final state = _getPositionState(position);
    final colors = Theme.of(context).colorScheme;

    final backgroundColor = switch (state) {
      TaskAnswerState.correct => Colors.green,
      TaskAnswerState.incorrect => colors.error,
      TaskAnswerState.neutral => isSelected ? colors.primary : colors.surface,
    };

    return Material(
      color: backgroundColor,
      child: InkWell(
        onTap: _isAnswered
            ? null
            : () => _onPositionSelected(position, isSelected),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.outline, width: 1),
          ),
          child: Center(child: _buildContent(content)),
        ),
      ),
    );
  }

  void _onPositionSelected(GridPosition position, bool isSelected) {
    if (_isAnswered) return;

    // Single selection without confirmation:
    // answer immediately.
    if (!_isMultiple && !_requiresConfirmation) {
      widget.onTaskAnswered(widget.task.checkAnswer([position]));
      return;
    }

    setState(() {
      // Single selection with confirmation:
      // only one position can be selected.
      if (!_isMultiple) {
        _selectedPositions
          ..clear()
          ..add(position);
        return;
      }

      // Multiple selection:
      // toggle the selected position.
      if (isSelected) {
        _selectedPositions.remove(position);
      } else {
        _selectedPositions.add(position);
      }
    });
  }

  Widget _buildContent(TaskContent content) {
    if (content is EmojiContent) {
      return Text(content.emoji, style: const TextStyle(fontSize: 40));
    }

    if (content is TextContent) {
      return Text(content.text, textAlign: TextAlign.center);
    }

    if (content is ImageContent) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Image.asset(content.imagePath, fit: BoxFit.contain),
      );
    }

    return const SizedBox.shrink();
  }

  void _confirmAnswer() {
    final answer = List<GridPosition>.from(_selectedPositions);

    widget.onTaskAnswered(widget.task.checkAnswer(answer));
  }

  TaskAnswerState _getPositionState(GridPosition position) {
    final result = widget.result;

    if (result == null) {
      return TaskAnswerState.neutral;
    }

    final selectedAnswer = result.selectedAnswer;

    // Single selection:
    // only the actually selected position gets
    // the final result color.
    if (!_isMultiple) {
      if (selectedAnswer != null && selectedAnswer.contains(position)) {
        return result.state;
      }

      return TaskAnswerState.neutral;
    }

    // Multiple selection:
    // all correct positions are green,
    // selected incorrect positions are red.
    final solution = result.solution?.value;

    if (solution != null && solution.contains(position)) {
      return TaskAnswerState.correct;
    }

    if (selectedAnswer != null && selectedAnswer.contains(position)) {
      return TaskAnswerState.incorrect;
    }

    return TaskAnswerState.neutral;
  }
}
