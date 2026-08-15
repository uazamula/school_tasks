import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/learning_task.dart';
import '../../domain/task_result.dart';

class ChoiceTaskWidget extends StatelessWidget {
  const ChoiceTaskWidget({
    super.key,
    required this.task,
    required this.onAnswerSelected,
    this.result,
  });

  final LearningTask task;
  final ValueChanged<int> onAnswerSelected;
  final TaskResult<int>? result;

  @override
  Widget build(BuildContext context) {
    final isAnswered = result?.isAnswered ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${task.firstNumber} + ${task.secondNumber} = ?',
          style: AppTextStyles.headline,
        ),

        const SizedBox(height: AppSpacing.xl),

        ...task.answers.map(
          (answer) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: SizedBox(
              width: 200,
              child: FilledButton(
                onPressed: isAnswered ? null : () => onAnswerSelected(answer),
                child: Text('$answer', style: AppTextStyles.title),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
