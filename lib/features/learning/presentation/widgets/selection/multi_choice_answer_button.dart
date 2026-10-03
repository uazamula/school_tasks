import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection/adaptive_button_text.dart';

class MultiChoiceAnswerButton extends StatelessWidget {
  const MultiChoiceAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.isSelected,
    required this.onPressed,
    required this.buttonConfig,
  });

  final String answer;
  final TaskAnswerState state;
  final bool isSelected;
  final VoidCallback? onPressed;
  final SelectionButtonConfig? buttonConfig;

  @override
  Widget build(BuildContext context) {
    final icon = _getIcon();
    final textStyle =
        Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontSize: buttonConfig?.fontSize) ??
        TextStyle(fontSize: buttonConfig?.fontSize);

    return SizedBox(
      width: buttonConfig?.buttonWidth ?? 280,
      height: buttonConfig?.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, size: 32),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: AdaptiveButtonText(
                text: answer,
                textStyle: textStyle,
                textScaler: buttonConfig?.textScaler,
              ),
            ),
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
