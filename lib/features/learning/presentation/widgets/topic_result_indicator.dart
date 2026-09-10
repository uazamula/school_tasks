import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_tasks/core/formatters/duration_formatter.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/evaluation/topic_result_display.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/presentation/widgets/visual_grade_scale_widget.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';
import 'package:school_tasks/features/learning/providers/topic_result_display_controller.dart';

class TopicResultIndicator extends ConsumerWidget {
  const TopicResultIndicator({super.key, required this.result});

  final TopicResult? result;

  static const double _gradeFontSize = 20;
  static const double _durationFontSize = 12;
  static const double _visualSize = 46;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (result == null) {
      return const Text('-');
    }

    final gradeScaleAsync = ref.watch(gradeScaleControllerProvider);
    final displayAsync = ref.watch(topicResultDisplayControllerProvider);

    if (gradeScaleAsync.isLoading || displayAsync.isLoading) {
      return const Text('-');
    }

    if (gradeScaleAsync.hasError || displayAsync.hasError) {
      return const Text('-');
    }

    final gradeScale = gradeScaleAsync.value!;
    final display = displayAsync.value!;

    final duration = DurationFormatter.formatShort(
      context,
      result!.currentDuration,
    );

    return switch (display) {
      TopicResultDisplay.grade => _buildGrade(gradeScale, result!.currentScore),

      TopicResultDisplay.duration => _buildDuration(duration),

      TopicResultDisplay.gradeAndDuration => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildGrade(gradeScale, result!.currentScore),
          const SizedBox(height: 1),
          _buildDuration(duration),
        ],
      ),
    };
  }

  Widget _buildGrade(GradeScale scale, double score) {
    if (scale == GradeScale.visual) {
      return Center(
        child: SizedBox(
          width: _visualSize,
          height: _visualSize,
          child: FittedBox(
            fit: BoxFit.contain,
            child: VisualGradeScaleWidget(score: score, size: _visualSize),
          ),
        ),
      );
    }

    return Text(
      scale.formatScore(score),
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: _gradeFontSize,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDuration(String duration) {
    return Text(
      duration,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: _durationFontSize),
    );
  }
}
