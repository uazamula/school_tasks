import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/presentation/widgets/visual_grade_scale_widget.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

class TopicResultIndicator extends ConsumerWidget {
  const TopicResultIndicator({super.key, required this.result});

  final TopicResult? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (result == null) {
      return const Text('-', style: AppTextStyles.body);
    }

    final gradeScaleAsync = ref.watch(gradeScaleControllerProvider);

    final displayAsync = ref.watch(topicResultDisplayControllerProvider);

    if (gradeScaleAsync.isLoading || displayAsync.isLoading) {
      return const Text('-', style: AppTextStyles.body);
    }

    if (gradeScaleAsync.hasError || displayAsync.hasError) {
      return const Text('-', style: AppTextStyles.body);
    }

    final gradeScale = gradeScaleAsync.value!;
    final display = displayAsync.value!;

    final resultContent = switch (gradeScale) {
      GradeScale.visual => VisualGradeScaleWidget(
        score: result!.currentScore,
        size: 32,
      ),

      GradeScale.hundred ||
      GradeScale.twelve => _buildTextResult(context, gradeScale, display),
    };

    return resultContent;
  }

  Widget _buildTextResult(
    BuildContext context,
    GradeScale gradeScale,
    TopicResultDisplay display,
  ) {
    final grade = gradeScale.formatScore(result!.currentScore);

    final duration = DurationFormatter.formatShort(
      context,
      result!.currentDuration,
    );

    return switch (display) {
      TopicResultDisplay.grade => Text(grade, style: AppTextStyles.body),

      TopicResultDisplay.duration => Text(duration, style: AppTextStyles.body),

      TopicResultDisplay.gradeAndDuration => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(grade, style: AppTextStyles.body),
          Text(duration, style: AppTextStyles.body),
        ],
      ),
    };
  }
}
