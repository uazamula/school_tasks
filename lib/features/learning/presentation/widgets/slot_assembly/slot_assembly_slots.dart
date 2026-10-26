import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';

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

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
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
              return Container(
                key: slotKeys[i],
                constraints: const BoxConstraints(minWidth: 64, minHeight: 56),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.md,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outline),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(slots[i], style: theme.textTheme.titleMedium),
              );
            },
          ),
      ],
    );
  }
}
