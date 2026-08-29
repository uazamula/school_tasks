import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../routing/app_routes.dart';
import '../../domain/learning_node.dart';

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
        return _TopicResultDialog(
          result: result!,
          onResetResult: onResetResult,
        );
      },
    );
  }
}

class _TopicResultDialog extends ConsumerWidget {
  const _TopicResultDialog({required this.result, required this.onResetResult});

  final TopicResult result;
  final VoidCallback? onResetResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gradeScaleAsync = ref.watch(gradeScaleControllerProvider);

    return AlertDialog(
      title: const Text('Результат'),
      content: gradeScaleAsync.when(
        loading: () => const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Text('Помилка: $error'),
        data: (scale) => _buildContent(scale),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            final shouldReset = await _confirmReset(context);

            if (shouldReset != true || !context.mounted) {
              return;
            }

            Navigator.pop(context);
            onResetResult?.call();
          },
          child: const Text('Скинути'),
        ),

        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Закрити'),
        ),
      ],
    );
  }

  Widget _buildContent(GradeScale scale) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Поточний результат: '
          '${scale.formatScore(result.currentScore)}',
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'Зараховано: '
          '${result.currentIsPassed ? 'так' : 'ні'}',
        ),

        const SizedBox(height: AppSpacing.sm),

        Text(
          'Час: '
          '${result.currentDuration.inMilliseconds / 1000}'
          ' с',
        ),

        const SizedBox(height: AppSpacing.md),

        Text(
          'Найкращий результат: '
          '${scale.formatScore(result.bestScore)}',
        ),

        if (result.bestDuration != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Час найкращого результату: '
            '${result.bestDuration!.inMilliseconds / 1000}'
            ' с',
          ),
        ],
      ],
    );
  }

  Future<bool?> _confirmReset(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Скинути результат?'),
          content: const Text(
            'Поточний і найкращий результат цієї теми '
            'буде видалено назавжди.',
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(false),
              child: const Text('Ні'),
            ),
            FilledButton(
              onPressed: () => context.pop(true),
              child: const Text('Так, скинути'),
            ),
          ],
        );
      },
    );
  }
}
