import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class ChoiceAnswerButton extends StatelessWidget {
  const ChoiceAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.onPressed,
    required this.isSelected,
  });

  final String answer;
  final TaskAnswerState state;
  final VoidCallback? onPressed;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: FilledButton(
        onPressed: onPressed,
        style: _buttonStyle(context),
        child: Text(answer, style: AppTextStyles.title),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    if (isSelected) {
      final colors = Theme.of(context).colorScheme;

      return FilledButton.styleFrom(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        side: BorderSide(color: colors.primary, width: 3),
        elevation: 6,
      );
    }

    switch (state) {
      case TaskAnswerState.neutral:
        return FilledButton.styleFrom();
      case TaskAnswerState.correct:
        return FilledButton.styleFrom(
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.green,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
        );
      case TaskAnswerState.incorrect:
        return FilledButton.styleFrom(
          backgroundColor: Colors.red,
          disabledBackgroundColor: Colors.red,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
        );
    }
  }
}
