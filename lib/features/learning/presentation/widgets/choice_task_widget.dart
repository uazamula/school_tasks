import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/learning_task.dart';
import '../../domain/task_answer_state.dart';
import '../../domain/task_result.dart';
import 'choice_answer_button.dart';

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
            child: ChoiceAnswerButton(
              answer: answer,
              state: _getAnswerState(answer),
              onPressed: isAnswered ? null : () => onAnswerSelected(answer),
            ),
          ),
        ),
      ],
    );
  }

  TaskAnswerState _getAnswerState(int answer) {
    if (result == null) {
      return TaskAnswerState.neutral;
    }

    if (answer == result!.correctAnswer) {
      return TaskAnswerState.correct;
    }

    if (answer == result!.selectedAnswer) {
      return TaskAnswerState.incorrect;
    }

    return TaskAnswerState.neutral;
  }
}
