import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_criterion.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_evaluation_config.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

class TopicEvaluationDetails extends StatelessWidget {
  const TopicEvaluationDetails({
    super.key,
    required this.topic,
    required this.result,
    required this.initiallyExpanded,
    required this.onExpansionChanged,
  });

  final Topic topic;
  final TopicResult? result;
  final bool initiallyExpanded;
  final ValueChanged<bool> onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      initiallyExpanded: initiallyExpanded,
      title: const Text('Як формується оцінка'),
      onExpansionChanged: onExpansionChanged,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.sm,
            right: AppSpacing.sm,
            bottom: AppSpacing.sm,
          ),
          child: _buildContent(context),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
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
        Text(
          'Точність — вага '
          '${_formatPercent(context, accuracyWeight)}',
        ),
      );
    }

    if (timeWeight > 0 && timeConfig != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: AppSpacing.sm));
      }

      children.add(
        Text(
          'Час — вага '
          '${_formatPercent(context, timeWeight)}',
        ),
      );

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

    final maximumPassingTime = topic.passingCriteria?.maximumTime;

    if (maximumPassingTime != null) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: AppSpacing.sm));
      }

      children.add(
        Text(
          'Максимальний час для зарахування: '
          '${DurationFormatter.formatDetailed(context, maximumPassingTime)} '
          '${context.l10n.secondsShort}',
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

      // Для незарахованої спроби точність не відновлюємо.
      if (result!.currentIsPassed) {
        final accuracy = _reconstructAccuracy(
          result: result!,
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
        ).calculate(result!.currentDuration).score;

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

      if (result!.currentIsPassed) {
        children.add(
          Text(
            'Підсумкова оцінка: '
            '${_formatPercent(context, result!.currentScore)}',
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
}
