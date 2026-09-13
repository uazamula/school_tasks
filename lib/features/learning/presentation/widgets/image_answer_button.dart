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
    this.size = 160,
  });

  final ImageContent answer;
  final TaskAnswerState state;
  final bool isSelected;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
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
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Після відповіді результат має пріоритет.
    if (state == TaskAnswerState.correct) {
      return ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC8E6C9),
        foregroundColor: isDark ? Colors.white : const Color(0xFF1B5E20),
        disabledBackgroundColor: isDark
            ? const Color(0xFF2E7D32)
            : const Color(0xFFC8E6C9),
        disabledForegroundColor: isDark
            ? Colors.white
            : const Color(0xFF1B5E20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }

    if (state == TaskAnswerState.incorrect) {
      return ElevatedButton.styleFrom(
        backgroundColor: isDark
            ? const Color(0xFFC62828)
            : const Color(0xFFFFCDD2),
        foregroundColor: isDark ? Colors.white : const Color(0xFFB71C1C),
        disabledBackgroundColor: isDark
            ? const Color(0xFFC62828)
            : const Color(0xFFFFCDD2),
        disabledForegroundColor: isDark
            ? Colors.white
            : const Color(0xFFB71C1C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }

    // Вибраний, але відповідь ще не підтверджена.
    if (isSelected) {
      return ElevatedButton.styleFrom(
        backgroundColor: colors.primaryContainer,
        foregroundColor: colors.onPrimaryContainer,
        side: BorderSide(color: colors.primary, width: 3),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );
    }

    // Звичайний стан.
    return ElevatedButton.styleFrom(
      backgroundColor: isDark
          ? const Color(0xFF4A4A4A)
          : colors.surfaceContainerHighest,
      foregroundColor: isDark ? Colors.white : colors.onSurface,
      elevation: isDark ? 3 : 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
