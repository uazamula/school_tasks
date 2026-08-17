import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../domain/learning_node.dart';

class TopicDialog extends StatelessWidget {
  const TopicDialog({super.key, required this.topic});

  final LearningNode topic;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(topic.titleKey),
      content: const SizedBox.shrink(),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () async {
            final result = await context.push<TopicAttemptResult>(
              AppRoutes.learningFor(topic.id),
            );

            if (context.mounted) {
              Navigator.pop(context, result);
            }
          },
          child: const Text('Почати'),
        ),
        const SizedBox(height: AppSpacing.sm),
        const FilledButton(onPressed: null, child: Text('Результати')),
        const SizedBox(height: AppSpacing.sm),
        const FilledButton(onPressed: null, child: Text('Довідка')),
      ],
    );
  }
}
