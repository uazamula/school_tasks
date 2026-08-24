import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/evaluation/evaluation_criterion_type.dart';
import '../../domain/evaluation/evaluation_result.dart';

class EvaluationResultView extends StatelessWidget {
  const EvaluationResultView({super.key, required this.evaluation});

  final EvaluationResult evaluation;

  @override
  Widget build(BuildContext context) {
    final accuracy =
        evaluation.criterionResults[EvaluationCriterionType.accuracy];

    final time = evaluation.criterionResults[EvaluationCriterionType.time];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (accuracy != null) ...[
          Text('Точність: ${(accuracy.score * 100).round()}%'),
          const SizedBox(height: AppSpacing.sm),
          Text('Вага: ${(accuracy.weight * 100).round()}%'),
        ],

        if (time != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text('Час: ${time.measurement.toStringAsFixed(1)} с'),
          const SizedBox(height: AppSpacing.sm),
          Text('Оцінка за час: ${(time.score * 100).round()}%'),
          const SizedBox(height: AppSpacing.sm),
          Text('Вага: ${(time.weight * 100).round()}%'),
        ],

        const SizedBox(height: AppSpacing.md),

        Text(
          'Загальна оцінка: '
          '${(evaluation.finalScore * 100).round()}%',
        ),
      ],
    );
  }
}
