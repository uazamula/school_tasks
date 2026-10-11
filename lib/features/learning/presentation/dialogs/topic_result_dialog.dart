import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:school_tasks/core/extensions/context_extension.dart';

import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_snapshot.dart';
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
            _buildAttemptSummary(
              context,
              title: 'Остання спроба',
              snapshot: result.currentAttempt,
              score: result.currentScore,
              scale: scale,
            ),

            const SizedBox(height: AppSpacing.md),

            if (result.bestAttempt != null)
              _buildAttemptSummary(
                context,
                title: 'Найкраща спроба',
                snapshot: result.bestAttempt!,
                score: result.bestScore,
                scale: scale,
              )
            else
              const Text(
                'Зарахованих спроб, які встановили найкращий результат, '
                'ще немає.',
              ),

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

  Widget _buildAttemptSummary(
    BuildContext context, {
    required String title,
    required TopicAttemptSnapshot snapshot,
    required double score,
    required GradeScale scale,
  }) {
    final locale = Localizations.localeOf(context);
    final dateFormatter = DateFormat.yMd(locale.toLanguageTag()).add_Hm();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.xs),
        Text('Дата: ${dateFormatter.format(snapshot.completedAt)}'),
        Text('Результат: ${scale.formatScore(score)}'),
        Text('Зараховано: ${snapshot.isPassed ? 'так' : 'ні'}'),
        Text(
          'Завдань виконано: '
          '${snapshot.completedTasks} із ${snapshot.totalTasks}',
        ),
        Text(
          'Точність: ${snapshot.accuracy.correct} '
          'із ${snapshot.accuracy.total} '
          '(${(snapshot.accuracy.value * 100).toStringAsFixed(1)}%)',
        ),
        Text(
          'Тривалість: '
          '${DurationFormatter.formatDetailed(context, snapshot.duration)} '
          '${context.l10n.secondsShort}',
        ),
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
