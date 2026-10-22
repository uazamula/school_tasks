import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';

class SlotAssemblySlots extends StatelessWidget {
  const SlotAssemblySlots({
    super.key,
    required this.slots,
    required this.slotKeys,
  });

  final List<String> slots;
  final List<GlobalKey> slotKeys;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        for (var i = 0; i < slots.length; i++)
          Container(
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
          ),
      ],
    );
  }
}
