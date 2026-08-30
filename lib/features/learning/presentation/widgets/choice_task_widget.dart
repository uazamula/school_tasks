import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/choice_task.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/task_answer_state.dart';
import '../../domain/task_result.dart';
import 'choice_answer_button.dart';
import 'task_prompt_widget.dart';

class ChoiceTaskWidget extends StatelessWidget {
  const ChoiceTaskWidget({
    super.key,
    required this.task,
    required this.onTaskAnswered,
    this.result,
  });

  final ChoiceTask task;
  final ValueChanged<TaskResult<int>> onTaskAnswered;
  final TaskResult<int>? result;

  @override
  Widget build(BuildContext context) {
    final isAnswered = result?.isAnswered ?? false;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: task.prompt),

        const SizedBox(height: AppSpacing.xl),

        ...task.answers.map(
          (answer) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ChoiceAnswerButton(
              answer: answer,
              state: _getAnswerState(answer),
              onPressed: isAnswered
                  ? null
                  : () => onTaskAnswered(task.checkAnswer(answer)),
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
