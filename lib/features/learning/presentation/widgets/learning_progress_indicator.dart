import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';

class LearningProgressIndicator extends StatelessWidget {
  const LearningProgressIndicator({
    super.key,
    required this.progress,
    required this.totalSteps,
    required this.elapsed,
  });

  final int progress;
  final int totalSteps;
  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final progressValue = totalSteps == 0
        ? 0.0
        : (progress / totalSteps).clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(value: progressValue, minHeight: 12),
          ),
        ),

        const SizedBox(width: AppSpacing.md),

        Text(
          _formatDuration(elapsed),
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
