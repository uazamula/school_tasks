
import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';

class SlotAssemblyOptions extends StatelessWidget {
  const SlotAssemblyOptions({
    super.key,
    required this.itemCount,
    required this.isOptionVisible,
    required this.optionKey,
    required this.optionBuilder,
  });

  final int itemCount;
  final bool Function(int index) isOptionVisible;
  final Key Function(int index) optionKey;
  final Widget Function(int index) optionBuilder;

  List<List<int>> _buildOptionRows() {
    if (itemCount == 0) return [];

    const maxColumns = 4;
    final rowCount = (itemCount / maxColumns).ceil();
    final baseCount = itemCount ~/ rowCount;
    final extraCount = itemCount % rowCount;

    var index = 0;

    return List.generate(rowCount, (rowIndex) {
      final count = baseCount + (rowIndex < extraCount ? 1 : 0);

      final row = List.generate(
        count,
            (_) => index++,
      );

      return row;
    });
  }

  Widget _buildOptionSlot(int index) {
    return Visibility(
      key: ValueKey(index),
      visible: isOptionVisible(index),
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: KeyedSubtree(
        key: optionKey(index),
        child: optionBuilder(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildOptionRows();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
          if (rowIndex > 0)
            const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var columnIndex = 0;
              columnIndex < rows[rowIndex].length;
              columnIndex++) ...[
                if (columnIndex > 0)
                  const SizedBox(width: AppSpacing.md),
                _buildOptionSlot(rows[rowIndex][columnIndex]),
              ],
            ],
          ),
        ],
      ],
    );
  }
}
