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
      //todo add logic here
      width: 160,
      height: 160,
      child: FilledButton(
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
