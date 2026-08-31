import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class MultiChoiceAnswerButton extends StatelessWidget {
  const MultiChoiceAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.isSelected,
    required this.onPressed,
  });

  final String answer;
  final TaskAnswerState state;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();

    return SizedBox(
      width: 280,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(answer, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    if (state == TaskAnswerState.correct) {
      return Icons.check_box;
    }

    if (state == TaskAnswerState.incorrect) {
      return Icons.close;
    }

    if (isSelected) {
      return Icons.check_box;
    }

    return Icons.check_box_outline_blank;
  }
}
