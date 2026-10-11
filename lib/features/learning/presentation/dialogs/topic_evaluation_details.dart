import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:school_tasks/core/extensions/context_extension.dart';
import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_completion_reason.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
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
    final children = <Widget>[
      const Text(
        'Налаштування оцінювання',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: AppSpacing.xs),
      ..._buildEvaluationConfiguration(context),
    ];

    final minimumAccuracy = topic.passingCriteria?.minimumAccuracy;
    final maximumPassingTime = topic.passingCriteria?.maximumTime;

    if (minimumAccuracy != null || maximumPassingTime != null) {
      children.add(const SizedBox(height: AppSpacing.md));
      children.add(
        const Text(
          'Умови зарахування',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      children.add(const SizedBox(height: AppSpacing.xs));

      if (minimumAccuracy != null) {
        children.add(
          Text(
            'Мінімальна точність: '
            '${_formatPercent(context, minimumAccuracy)}',
          ),
        );
      }

      if (maximumPassingTime != null) {
        children.add(
          Text(
            'Максимальний час: '
            '${_formatDuration(context, maximumPassingTime)}',
          ),
        );
      }
    }

    if (result != null) {
      children.add(const SizedBox(height: AppSpacing.md));
      children.add(
        const Text(
          'Результати останньої спроби',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      );
      children.add(const SizedBox(height: AppSpacing.xs));
      children.addAll(_buildAttemptDetails(context));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  List<Widget> _buildEvaluationConfiguration(BuildContext context) {
    final evaluation = topic.evaluation;
    final children = <Widget>[];

    final accuracyWeight = evaluation.normalizedWeight(
      EvaluationCriterionType.accuracy,
    );

    final timeWeight = evaluation.normalizedWeight(
      EvaluationCriterionType.time,
    );

    if (accuracyWeight > 0) {
      children.add(
        Text(
          'Точність: вага '
          '${_formatPercent(context, accuracyWeight)}',
        ),
      );
    }

    final timeConfig = evaluation.time;

    if (timeWeight > 0 && timeConfig != null) {
      children.add(Text('Час: вага ${_formatPercent(context, timeWeight)}'));
      children.add(
        Text(
          'Цільовий час: ${_formatDuration(context, timeConfig.targetTime)}',
        ),
      );
      children.add(
        Text(
          'Граничний час критерію: '
          '${_formatDuration(context, timeConfig.maximumTime)}',
        ),
      );
    }

    if (children.isEmpty) {
      children.add(const Text('Не налаштовано критерії з додатною вагою.'));
    }

    return children;
  }

  List<Widget> _buildAttemptDetails(BuildContext context) {
    final snapshot = result!.currentAttempt;
    final children = <Widget>[
      Text(
        'Виконано завдань: '
        '${snapshot.completedTasks} із ${snapshot.totalTasks}',
      ),
      Text(
        'Правильність відповідей: '
        '${snapshot.accuracy.correct} із ${snapshot.accuracy.total} '
        '(${_formatPercent(context, snapshot.accuracy.value)})',
      ),
      Text('Тривалість: ${_formatDuration(context, snapshot.duration)}'),
      Text(
        'Причина завершення: '
        '${_completionReasonLabel(snapshot.completionReason)}',
      ),
    ];

    final evaluation = snapshot.evaluation;

    children.add(const SizedBox(height: AppSpacing.sm));

    if (evaluation == null || evaluation.criterionResults.isEmpty) {
      children.add(
        const Text('Детальний розрахунок оцінки для цієї спроби недоступний.'),
      );
    } else {
      children.add(
        const Text(
          'Розрахунок за критеріями',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      );
      children.add(const SizedBox(height: AppSpacing.xs));

      for (final entry in evaluation.criterionResults.entries) {
        final criterion = entry.key;
        final criterionResult = entry.value;

        children.add(
          Text(
            _criterionLabel(criterion),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        );

        if (criterion == EvaluationCriterionType.accuracy) {
          children.add(
            Text(
              'Фактична точність: '
              '${_formatPercent(context, criterionResult.measurement)}',
            ),
          );
        } else if (criterion == EvaluationCriterionType.time) {
          children.add(
            Text(
              'Фактичний час: '
              '${_formatDuration(context, Duration(milliseconds: (criterionResult.measurement * 1000).round()))}',
            ),
          );
        }

        children.add(
          Text(
            'Оцінка критерію: '
            '${_formatPercent(context, criterionResult.score)}',
          ),
        );
        children.add(
          Text(
            'Вага у фінальній оцінці: '
            '${_formatPercent(context, criterionResult.weight)}',
          ),
        );
        children.add(
          Text(
            'Внесок у фінальну оцінку: '
            '${_formatPercent(context, criterionResult.weightedScore)}',
          ),
        );
        children.add(const SizedBox(height: AppSpacing.sm));
      }

      children.add(
        Text(
          'Оцінка за критеріями: '
          '${_formatPercent(context, evaluation.finalScore)}',
        ),
      );

      if (!snapshot.isPassed) {
        children.add(
          Text(
            'Підсумковий результат спроби: '
            '0 — тему не зараховано.',
          ),
        );
      }
    }

    children.add(const SizedBox(height: AppSpacing.sm));
    children.add(
      const Text(
        'Перевірка умов зарахування',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );

    final minimumAccuracy = topic.passingCriteria?.minimumAccuracy;
    final maximumPassingTime = topic.passingCriteria?.maximumTime;

    if (minimumAccuracy == null && maximumPassingTime == null) {
      children.add(const Text('Додаткових умов зарахування не налаштовано.'));
    }

    if (minimumAccuracy != null) {
      final passed = snapshot.accuracy.value >= minimumAccuracy;

      children.add(
        _buildConditionResult(
          label:
              'Мінімальна точність: '
              '${_formatPercent(context, minimumAccuracy)}',
          passed: passed,
        ),
      );
    }

    if (maximumPassingTime != null) {
      final passed = snapshot.duration <= maximumPassingTime;

      children.add(
        _buildConditionResult(
          label:
              'Максимальний час: '
              '${_formatDuration(context, maximumPassingTime)}',
          passed: passed,
        ),
      );
    }

    return children;
  }

  Widget _buildConditionResult({required String label, required bool passed}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            passed ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 18,
            color: passed ? Colors.green : Colors.red,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text('$label — ${passed ? 'виконано' : 'не виконано'}'),
          ),
        ],
      ),
    );
  }

  String _criterionLabel(EvaluationCriterionType criterion) {
    return switch (criterion) {
      EvaluationCriterionType.accuracy => 'Точність',
      EvaluationCriterionType.time => 'Час',
    };
  }

  String _completionReasonLabel(TopicCompletionReason reason) {
    return switch (reason) {
      TopicCompletionReason.completed => 'Усі завдання завершено',
      TopicCompletionReason.timeExpired => 'Час вичерпано',
      TopicCompletionReason.failureLimitReached => 'Досягнуто ліміту помилок',
    };
  }

  String _formatDuration(BuildContext context, Duration duration) {
    return '${DurationFormatter.formatDetailed(context, duration)} '
        '${context.l10n.secondsShort}';
  }

  String _formatPercent(BuildContext context, double value) {
    final locale = Localizations.localeOf(context);

    final formatter = NumberFormat.decimalPattern(locale.toLanguageTag())
      ..minimumFractionDigits = 1
      ..maximumFractionDigits = 1;

    return '${formatter.format(value * 100)}%';
  }
}
