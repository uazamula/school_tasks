import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';

import '../../domain/task_answer_state.dart';
import '../../domain/task_result.dart';
import 'multi_choice_answer_button.dart';

class MultiChoiceAnswers extends StatelessWidget {
  const MultiChoiceAnswers({
    super.key,
    required this.answers,
    required this.selectedAnswers,
    required this.result,
    required this.onAnswerSelected,
    required this.enabled,
  });

  final List<String> answers;
  final Set<String> selectedAnswers;
  final TaskResult<List<String>>? result;
  final ValueChanged<String> onAnswerSelected;
  final bool enabled;

  TaskAnswerState _getAnswerState(String answer) {
    if (result == null) {
      return TaskAnswerState.neutral;
    }

    final correctAnswers = result!.correctAnswer ?? [];
    final selectedAnswers = result!.selectedAnswer ?? [];

    if (correctAnswers.contains(answer)) {
      return TaskAnswerState.correct;
    }

    if (selectedAnswers.contains(answer)) {
      return TaskAnswerState.incorrect;
    }

    return TaskAnswerState.neutral;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...answers.map(
          (answer) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: MultiChoiceAnswerButton(
              answer: answer,
              state: _getAnswerState(answer),
              isSelected: selectedAnswers.contains(answer),
              onPressed: enabled ? () => onAnswerSelected(answer) : null,
            ),
          ),
        ),
      ],
    );
  }
}
