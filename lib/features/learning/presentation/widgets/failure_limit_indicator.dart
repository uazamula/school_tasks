import 'package:flutter/material.dart';

class FailureLimitIndicator extends StatelessWidget {
  const FailureLimitIndicator({
    super.key,
    required this.failureLimit,
    required this.failureCount,
  });

  final int failureLimit;
  final int failureCount;

  @override
  Widget build(BuildContext context) {
    final remaining = (failureLimit - failureCount).clamp(0, failureLimit);

    return Tooltip(
      message: 'Помилок до завершення теми',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.favorite_border,
            size: 20,
            color: remaining <= 1
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 4),
          Text('$remaining', style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
