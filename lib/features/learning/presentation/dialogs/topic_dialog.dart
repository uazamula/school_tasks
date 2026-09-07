import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_criterion.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/learning_node.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';
import 'package:school_tasks/routing/app_routes.dart';

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
        return _TopicResultDialog(
          topic: topic,
          result: result,
          onResetResult: onResetResult,
        );
      },
    );
  }
}

class _TopicResultDialog extends ConsumerStatefulWidget {
  const _TopicResultDialog({
    required this.topic,
    required this.result,
    required this.onResetResult,
  });

  final Topic topic;
  final TopicResult? result;
  final VoidCallback? onResetResult;

  @override
  ConsumerState<_TopicResultDialog> createState() => _TopicResultDialogState();
}

class _TopicResultDialogState extends ConsumerState<_TopicResultDialog> {
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

          _buildEvaluationDetails(context, result),
        ],
      ),
    );
  }

  Widget _buildEvaluationDetails(BuildContext context, TopicResult? result) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: _showEvaluationDetails,
      title: const Text('Як формується оцінка'),
      onExpansionChanged: (expanded) {
        setState(() {
          _showEvaluationDetails = expanded;
        });
      },
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: _buildEvaluationContent(context, result),
        ),
      ],
    );
  }

  Widget _buildEvaluationContent(BuildContext context, TopicResult? result) {
    final topic = widget.topic;
    final evaluation = topic.evaluation;

    final accuracyWeight = evaluation.normalizedWeight(
      EvaluationCriterionType.accuracy,
    );

    final timeWeight = evaluation.normalizedWeight(
      EvaluationCriterionType.time,
    );

    final timeConfig = evaluation.time;

    final children = <Widget>[];

    if (accuracyWeight > 0) {
      children.add(
        Text('Точність — вага ${_formatPercent(context, accuracyWeight)}'),
      );
    }

    if (timeWeight > 0 && timeConfig != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: AppSpacing.sm));
      }

      children.add(Text('Час — вага ${_formatPercent(context, timeWeight)}'));

      children.add(const SizedBox(height: AppSpacing.xs));

      children.add(
        Text(
          'Оптимальний час: '
          '${DurationFormatter.formatDetailed(context, timeConfig.targetTime)} '
          '${context.l10n.secondsShort}',
        ),
      );

      children.add(
        Text(
          'Максимальний час: '
          '${DurationFormatter.formatDetailed(context, timeConfig.maximumTime)} '
          '${context.l10n.secondsShort}',
        ),
      );
    }

    final minimumAccuracy = topic.passingCriteria?.minimumAccuracy;

    if (minimumAccuracy != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: AppSpacing.sm));
      }

      children.add(
        Text(
          'Мінімальна точність для зарахування: '
          '${_formatPercent(context, minimumAccuracy)}',
        ),
      );
    }

    if (result != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: AppSpacing.md));
      }

      children.add(
        const Text(
          'Остання спроба:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );

      children.add(const SizedBox(height: AppSpacing.xs));

      if (result.currentIsPassed) {
        final accuracy = _reconstructAccuracy(
          result: result,
          accuracyWeight: accuracyWeight,
          timeWeight: timeWeight,
          timeConfig: timeConfig,
        );

        if (accuracy != null) {
          children.add(
            Text(
              'Точність: '
              '${_formatPercent(context, accuracy)}',
            ),
          );
        }
      }

      if (timeWeight > 0 && timeConfig != null) {
        final timeScore = TimeCriterion(
          targetTime: timeConfig.targetTime,
          maximumTime: timeConfig.maximumTime,
        ).calculate(result.currentDuration).score;

        children.add(
          Text(
            'Оцінка за час: '
            '${_formatPercent(context, timeScore)}',
          ),
        );

        children.add(
          Text(
            'Внесок часу в оцінку: '
            '${_formatPercent(context, timeScore * timeWeight)}',
          ),
        );
      }

      if (result.currentIsPassed) {
        children.add(
          Text(
            'Підсумкова оцінка: '
            '${_formatPercent(context, result.currentScore)}',
          ),
        );
      } else {
        children.add(
          const Text(
            'Підсумковий результат спроби: 0 '
            '(тему не зараховано)',
          ),
        );
      }
    }

    if (children.isEmpty) {
      return const Text('Для цієї теми не налаштовано критерії оцінювання.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  double? _reconstructAccuracy({
    required TopicResult result,
    required double accuracyWeight,
    required double timeWeight,
    required TimeEvaluationConfig? timeConfig,
  }) {
    if (accuracyWeight <= 0) {
      return null;
    }

    if (timeWeight <= 0 || timeConfig == null) {
      return result.currentScore.clamp(0.0, 1.0);
    }

    final timeScore = TimeCriterion(
      targetTime: timeConfig.targetTime,
      maximumTime: timeConfig.maximumTime,
    ).calculate(result.currentDuration).score;

    final accuracy =
        (result.currentScore - timeScore * timeWeight) / accuracyWeight;

    return accuracy.clamp(0.0, 1.0);
  }

  String _formatPercent(BuildContext context, double value) {
    final locale = Localizations.localeOf(context);

    final formatter = NumberFormat.decimalPattern(locale.toLanguageTag())
      ..minimumFractionDigits = 1
      ..maximumFractionDigits = 1;

    return '${formatter.format(value * 100)}%';
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
