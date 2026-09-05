import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/evaluation/grade_scale.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/providers/grade_scale_controller.dart';

class TopicResultIndicator extends ConsumerWidget {
  const TopicResultIndicator({super.key, required this.result});

  final TopicResult? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (result == null) {
      return const Text('-', style: AppTextStyles.body);
    }

    final gradeScale = ref.watch(gradeScaleControllerProvider);

    return gradeScale.when(
      loading: () => const Text('-', style: AppTextStyles.body),
      error: (_, _) => const Text('-', style: AppTextStyles.body),
      data: (scale) {
        return Text(
          scale.formatScore(result!.currentScore),
          style: AppTextStyles.body,
        );
      },
    );
  }
}
