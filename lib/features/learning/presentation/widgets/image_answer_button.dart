import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class ImageAnswerButton extends StatelessWidget {
  const ImageAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.isSelected,
    required this.onPressed,
  });

  final ImageContent answer;
  final TaskAnswerState state;
  final bool isSelected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: ElevatedButton(
        onPressed: onPressed,
        style: _buttonStyle(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(answer.imagePath, fit: BoxFit.contain),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    final theme = Theme.of(context);

    // Після відповіді результат має пріоритет.
    if (state == TaskAnswerState.correct) {
      return ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.green,
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }

    if (state == TaskAnswerState.incorrect) {
      return ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.red,
        disabledForegroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }

    // Вибраний, але відповідь ще не підтверджена.
    if (isSelected) {
      return ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
        side: BorderSide(color: theme.colorScheme.primary, width: 3),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }

    // Звичайний стан.
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
