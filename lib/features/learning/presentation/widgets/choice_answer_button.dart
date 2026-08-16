import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../domain/task_answer_state.dart';

class ChoiceAnswerButton extends StatelessWidget {
  const ChoiceAnswerButton({
    super.key,
    required this.answer,
    required this.state,
    required this.onPressed,
  });

  final int answer;
  final TaskAnswerState state;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: FilledButton(
        onPressed: onPressed,
        style: _buttonStyle(context),
        child: Text('$answer', style: AppTextStyles.title),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context) {
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
