import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/task_data/selection_button_config.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection/adaptive_button_text.dart';

class ChoiceAnswerButton extends StatelessWidget {
  const ChoiceAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.onPressed,
    required this.isSelected,
    required this.buttonConfig,
  });

  final String answer;
  final TaskAnswerState state;
  final VoidCallback? onPressed;
  final bool isSelected;
  final SelectionButtonConfig? buttonConfig;

  @override
  Widget build(BuildContext context) {
    final textStyle = buttonConfig == null
        ? AppTextStyles.title
        : AppTextStyles.title.copyWith(fontSize: buttonConfig!.fontSize);

    return SizedBox(
      width: buttonConfig?.buttonWidth ?? 200,
      height: buttonConfig?.buttonHeight,
      child: FilledButton(
        onPressed: onPressed,
        style: _buttonStyle(context),
        child: AdaptiveButtonText(
          text: answer,
          textStyle: textStyle,
          textScaler: buttonConfig?.textScaler,
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );

    switch (state) {
      case TaskAnswerState.correct:
        return FilledButton.styleFrom(
          backgroundColor: Colors.green,
          disabledBackgroundColor: Colors.green,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          side: isSelected
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
          shape: shape,
        );

      case TaskAnswerState.incorrect:
        return FilledButton.styleFrom(
          backgroundColor: Colors.red,
          disabledBackgroundColor: Colors.red,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
          side: isSelected
              ? BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                )
              : null,
          shape: shape,
        );

      case TaskAnswerState.neutral:
        if (isSelected) {
          final colors = Theme.of(context).colorScheme;

          return FilledButton.styleFrom(
            backgroundColor: colors.primaryContainer,
            foregroundColor: colors.onPrimaryContainer,
            side: BorderSide(color: colors.primary, width: 3),
            elevation: 6,
            shape: shape,
          );
        }

        return FilledButton.styleFrom(shape: shape);
    }
  }
}
