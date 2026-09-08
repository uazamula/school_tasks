import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';

import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';

import 'topic_evaluation_details.dart';

class TopicResultDialog extends ConsumerStatefulWidget {
  const TopicResultDialog({
    super.key,
    required this.topic,
    required this.result,
    required this.onResetResult,
  });

  final Topic topic;
  final TopicResult? result;
  final VoidCallback? onResetResult;

  @override
  ConsumerState<TopicResultDialog> createState() => _TopicResultDialogState();
}

class _TopicResultDialogState extends ConsumerState<TopicResultDialog> {
  bool _showEvaluationDetails = false;

  @override
  Widget build(BuildContext context) {
    final gradeScaleAsync = ref.watch(gradeScaleControllerProvider);

    return AlertDialog(
      title: const Text('Результат'),
      content: gradeScaleAsync.when(
        loading: () => const SizedBox(
          height: 50,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stackTrace) => Text('Помилка: $error'),
        data: (scale) => _buildContent(context, scale),
      ),
      actions: [
        if (widget.result != null)
          TextButton(
            onPressed: () async {
              final shouldReset = await _confirmReset(context);

              if (shouldReset != true || !context.mounted) {
                return;
              }

              Navigator.pop(context);
              widget.onResetResult?.call();
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

  Widget _buildContent(BuildContext context, GradeScale scale) {
    final result = widget.result;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result == null)
            const Text(
              'Ця тема ще не проходилася. '
              'Нижче наведено правила оцінювання.',
            )
          else ...[
            if (!result.currentIsPassed) ...[
              const Text(
                'Остання спроба не зарахована',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

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
              '${DurationFormatter.formatDetailed(context, result.currentDuration)} '
              '${context.l10n.secondsShort}',
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
                '${DurationFormatter.formatDetailed(context, result.bestDuration!)} '
                '${context.l10n.secondsShort}',
              ),
            ],

            const SizedBox(height: AppSpacing.md),
          ],

          TopicEvaluationDetails(
            topic: widget.topic,
            result: result,
            initiallyExpanded: _showEvaluationDetails,
            onExpansionChanged: (expanded) {
              setState(() {
                _showEvaluationDetails = expanded;
              });
            },
          ),
        ],
      ),
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
