import 'package:flutter/material.dart';

class FailureLimitIndicator extends StatelessWidget {
  const FailureLimitIndicator({
    super.key,
    required this.failureCount,
    this.failureLimit,
  });

  final int? failureLimit;
  final int failureCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final limit = failureLimit;

    if (limit == null) {
      return Tooltip(
        message: 'Кількість помилок не обмежена',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite, size: 20, color: colorScheme.error),
            const SizedBox(width: 4),
            Text('∞', style: theme.textTheme.titleSmall),
          ],
        ),
      );
    }

    final remaining = (limit - failureCount).clamp(0, limit);

    if (limit <= 3) {
      return Tooltip(
        message: 'Помилок до завершення теми: $remaining',
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(limit, (index) {
            final isAvailable = index < remaining;

            return Padding(
              padding: EdgeInsets.only(left: index == 0 ? 0 : 2),
              child: Icon(
                isAvailable ? Icons.favorite : Icons.favorite_border,
                size: 20,
                color: isAvailable
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
            );
          }),
        ),
      );
    }

    return Tooltip(
      message: 'Помилок до завершення теми: $remaining',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, size: 20, color: colorScheme.error),
          const SizedBox(width: 4),
          Text('$remaining', style: theme.textTheme.titleSmall),
        ],
      ),
    );
  }
}
