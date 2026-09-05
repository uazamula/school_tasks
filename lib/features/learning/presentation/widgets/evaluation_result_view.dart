import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/evaluation/evaluation_criterion_type.dart';
import '../../domain/evaluation/evaluation_result.dart';
import '../../domain/evaluation/grade_scale.dart';
import '../../providers/grade_scale_controller.dart';

class EvaluationResultView extends ConsumerWidget {
  const EvaluationResultView({super.key, required this.evaluation});

  final EvaluationResult evaluation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accuracy =
        evaluation.criterionResults[EvaluationCriterionType.accuracy];

    final time = evaluation.criterionResults[EvaluationCriterionType.time];

    final gradeScale = ref.watch(gradeScaleControllerProvider);

    return gradeScale.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (scale) {
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
              Text(
                'Оцінка за час: '
                '${scale.formatScore(time.score)}',
              ),
              const SizedBox(height: AppSpacing.sm),
              Text('Вага: ${(time.weight * 100).round()}%'),
            ],

            const SizedBox(height: AppSpacing.md),

            Text(
              'Загальна оцінка: '
              '${scale.formatScore(evaluation.finalScore)}',
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(evaluation.isPassed ? 'Зараховано' : 'Не зараховано'),
          ],
        );
      },
    );
  }
}
