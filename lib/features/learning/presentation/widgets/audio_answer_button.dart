import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

class AudioAnswerButton extends StatelessWidget {
  const AudioAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.isSelected,
    required this.isActive,
    required this.onPressed,
  });

  final AudioContent answer;
  final TaskAnswerState state;
  final bool isSelected;
  final bool isActive;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Material(
        color: _backgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Center(
              child: TaskAudioWidget(
                content: answer,
                isActive: isActive,
                iconColor: _foregroundColor(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _backgroundColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Після відповіді correct/incorrect має пріоритет
    // над isSelected.
    switch (state) {
      case TaskAnswerState.correct:
        return Colors.green;

      case TaskAnswerState.incorrect:
        return Colors.red;

      case TaskAnswerState.neutral:
        if (isSelected) {
          return colors.primaryContainer;
        }

        return colors.surfaceContainerHighest;
    }
  }

  Color _foregroundColor(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    switch (state) {
      case TaskAnswerState.correct:
      case TaskAnswerState.incorrect:
        return Colors.white;

      case TaskAnswerState.neutral:
        return colors.onSurface;
    }
  }
}
