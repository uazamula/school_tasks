import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

import 'topic_result_dialog.dart';

class TopicDialog extends StatelessWidget {
  const TopicDialog({
    super.key,
    required this.topicNode,
    required this.topic,
    this.result,
    this.onResetResult,
  });

  final LearningNode topicNode;
  final Topic topic;
  final TopicResult? result;
  final VoidCallback? onResetResult;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(topicNode.titleKey),
      content: const SizedBox.shrink(),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('Почати'),
        ),

        const SizedBox(height: AppSpacing.sm),

        FilledButton(
          onPressed: () {
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
        return TopicResultDialog(
          topic: topic,
          result: result,
          onResetResult: onResetResult,
        );
      },
    );
  }
}
