import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../domain/learning_node.dart';

class TopicDialog extends StatelessWidget {
  const TopicDialog({
    super.key,
    required this.topicNode,
    required this.topic,
    this.result,
  });

  final LearningNode topicNode;
  final Topic topic;
  final TopicAttemptResult? result;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(topicNode.titleKey),
      content: const SizedBox.shrink(),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () async {
            final attemptResult = await context.push<TopicAttemptResult>(
              AppRoutes.learningFor(topicNode.id),
            );

            if (context.mounted) {
              Navigator.pop(context, attemptResult);
            }
          },
          child: const Text('Почати'),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton(
          onPressed: result == null
              ? null
              : () {
                  _showResult(context);
                },
          child: const Text('Результати'),
        ),
        const SizedBox(height: AppSpacing.sm),
        FilledButton(
          onPressed: () {
            _showHelp(context);
          },
          child: const Text('Довідка'),
        ),
      ],
    );
  }

  void _showHelp(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Довідка'),
          content: Text(topic.help),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Закрити'),
            ),
          ],
        );
      },
    );
  }

  void _showResult(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Результат'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Виконано: '
                '${result!.completedTasks} / ${result!.totalTasks}',
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Правильних: '
                '${result!.correctTasks} / ${result!.totalTasks}',
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Результат: ${(result!.score * 100).round()}%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Закрити'),
            ),
          ],
        );
      },
    );
  }
}
