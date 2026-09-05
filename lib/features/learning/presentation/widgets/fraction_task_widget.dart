import 'dart:math';
import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/fraction_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class FractionTaskWidget extends StatefulWidget {
  const FractionTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final FractionTask task;
  final TaskResult<Set<int>, int>? result;
  final ValueChanged<TaskResult<Set<int>, int>> onTaskAnswered;

  @override
  State<FractionTaskWidget> createState() => _FractionTaskWidgetState();
}

class _FractionTaskWidgetState extends State<FractionTaskWidget> {
  final Set<int> _selectedParts = {};

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  @override
  void didUpdateWidget(covariant FractionTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _selectedParts.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: widget.task.prompt),
        const SizedBox(height: AppSpacing.xl),
        _buildCake(),
        const SizedBox(height: AppSpacing.lg),
        FilledButton(
          onPressed: _isAnswered || _selectedParts.isEmpty
              ? null
              : _confirmAnswer,
          child: const Text('Підтвердити'),
        ),
      ],
    );
  }

  Widget _buildCake() {
    final dimensions = _getGridDimensions(widget.task.parts);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = min(
          constraints.maxWidth,
          MediaQuery.sizeOf(context).height * 0.45,
        );

        const spacing = 1.0;

        final cellSize = min(
          (maxSize - spacing * (dimensions.columns - 1)) / dimensions.columns,
          (maxSize - spacing * (dimensions.rows - 1)) / dimensions.rows,
        );

        final width =
            cellSize * dimensions.columns + spacing * (dimensions.columns - 1);

        final height =
            cellSize * dimensions.rows + spacing * (dimensions.rows - 1);

        return SizedBox(
          width: width,
          height: height,
          child: GridView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: dimensions.columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemCount: widget.task.parts,
            itemBuilder: (context, index) {
              return _buildPart(index, dimensions.rows, dimensions.columns);
            },
          ),
        );
      },
    );
  }

  Widget _buildPart(int index, int rows, int columns) {
    final isSelected = _selectedParts.contains(index);
    final borderRadius = _getBorderRadius(index, rows, columns);
    final colors = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Material(
        color: isSelected ? colors.primary : const Color(0xFFFFE0B2),
        child: InkWell(
          onTap: _isAnswered
              ? null
              : () {
                  setState(() {
                    if (isSelected) {
                      _selectedParts.remove(index);
                    } else {
                      _selectedParts.add(index);
                    }
                  });
                },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: colors.outline, width: 1),
              borderRadius: borderRadius,
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _getBorderRadius(int index, int rows, int columns) {
    final row = index ~/ columns;
    final column = index % columns;

    const radius = Radius.circular(12);

    return BorderRadius.only(
      topLeft: row == 0 && column == 0 ? radius : Radius.zero,
      topRight: row == 0 && column == columns - 1 ? radius : Radius.zero,
      bottomLeft: row == rows - 1 && column == 0 ? radius : Radius.zero,
      bottomRight: row == rows - 1 && column == columns - 1
          ? radius
          : Radius.zero,
    );
  }

  void _confirmAnswer() {
    final answer = Set<int>.from(_selectedParts);

    widget.onTaskAnswered(widget.task.checkAnswer(answer));
  }

  _GridDimensions _getGridDimensions(int parts) {
    var bestRows = parts;
    var bestColumns = 1;

    for (var rows = 1; rows <= sqrt(parts); rows++) {
      if (parts % rows != 0) {
        continue;
      }

      final columns = parts ~/ rows;

      // Rows must be >= columns.
      final candidateRows = max(rows, columns);
      final candidateColumns = min(rows, columns);

      if (candidateRows / candidateColumns < bestRows / bestColumns) {
        bestRows = candidateRows;
        bestColumns = candidateColumns;
      }
    }

    return _GridDimensions(rows: bestRows, columns: bestColumns);
  }
}

class _GridDimensions {
  const _GridDimensions({required this.rows, required this.columns});

  final int rows;
  final int columns;
}
