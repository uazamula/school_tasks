import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

class TopicResultIndicator extends StatelessWidget {
  const TopicResultIndicator({super.key, required this.result});

  final TopicResult? result;

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return const Text('-', style: AppTextStyles.body);
    }

    return Text(
      '${(result!.currentScore * 100).round()}%',
      style: AppTextStyles.body,
    );
  }
}
