import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';

class TopicResultIndicator extends StatelessWidget {
  const TopicResultIndicator({super.key, required this.result});

  final TopicAttemptResult? result;

  @override
  Widget build(BuildContext context) {
    if (result == null || result!.evaluation == null) {
      return const Text('-', style: AppTextStyles.body);
    }

    return Text(
      '${(result!.evaluation!.finalScore * 100).round()}%',
      style: AppTextStyles.body,
    );
  }
}
