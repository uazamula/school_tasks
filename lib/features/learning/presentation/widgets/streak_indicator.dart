import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/evaluation/streak_progress.dart';

class StreakIndicator extends StatelessWidget {
  const StreakIndicator({super.key, required this.progress});

  final StreakProgress progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Tooltip(
      message: 'Поточна серія: ${progress.current}, найкраща: ${progress.best}',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 4),
          Text('${progress.current}', style: theme.textTheme.titleSmall),
          Text(
            ' / ${progress.best}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
