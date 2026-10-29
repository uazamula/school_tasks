import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly_task_widget.dart';

class SlotAssemblySlots extends StatelessWidget {
  const SlotAssemblySlots({
    super.key,
    required this.slots,
    required this.slotKeys,
    this.dragEnabled = false,
    this.occupiedSlots = const [],
    this.onOptionDropped,
  });

  final List<String> slots;
  final List<GlobalKey> slotKeys;
  final bool dragEnabled;
  final List<bool> occupiedSlots;
  final void Function(int optionIndex, int slotIndex)? onOptionDropped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final slotColor = Color.alphaBlend(
      theme.brightness == Brightness.light
          ? Colors.black.withValues(alpha: 0.06)
          : Colors.white.withValues(alpha: 0.08),
      colorScheme.surface,
    );

    const letterWidth = 26.0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (var i = 0; i < slots.length; i++)
          DragTarget<int>(
            onWillAcceptWithDetails: (details) {
              return dragEnabled &&
                  i < occupiedSlots.length &&
                  !occupiedSlots[i];
            },
            onAcceptWithDetails: (details) {
              onOptionDropped?.call(details.data, i);
            },
            builder: (context, candidateData, rejectedData) {
              final length = slots[i].length;
              return Container(
                key: slotKeys[i],
                constraints: BoxConstraints(
                  //todo
                  minWidth: slots[i] != nothing
                      ? letterWidth * length
                      : letterWidth * 2,
                  minHeight: 56,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: slotColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  slots[i],
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 38),
                ),
              );
            },
          ),
      ],
    );
  }
}
