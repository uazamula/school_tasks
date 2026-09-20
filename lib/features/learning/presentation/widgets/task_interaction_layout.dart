import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';

/// Marks an interaction whose layout/scaling is handled internally.
///
/// TopicLayoutWidget uses this marker to avoid applying its own FittedBox.
class TaskInteractionScalingBoundary extends StatelessWidget {
  const TaskInteractionScalingBoundary({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

/// Layout for interactions that have scalable content and an optional
/// non-scalable confirmation button.
class TaskInteractionLayout extends StatelessWidget {
  const TaskInteractionLayout({
    super.key,
    required this.content,
    required this.scrollable,
    this.confirmation,
  });

  final Widget content;
  final bool scrollable;
  final Widget? confirmation;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          content,
          if (confirmation != null) ...[
            const SizedBox(height: AppSpacing.lg),
            confirmation!,
          ],
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: Center(
            child: FittedBox(fit: BoxFit.contain, child: content),
          ),
        ),
        if (confirmation != null) ...[
          const SizedBox(height: AppSpacing.lg),
          confirmation!,
        ],
      ],
    );
  }
}
