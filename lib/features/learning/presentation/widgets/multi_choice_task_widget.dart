import 'package:flutter/material.dart';

import '../../domain/multi_choice_task.dart';
import '../../domain/task_answer_state.dart';
import '../../domain/task_result.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class MultiChoiceTaskWidget extends StatefulWidget {
  const MultiChoiceTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final MultiChoiceTask task;
  final TaskResult<List<String>>? result;
  final ValueChanged<TaskResult<List<String>>> onTaskAnswered;

  @override
  State<MultiChoiceTaskWidget> createState() => _MultiChoiceTaskWidgetState();
}

class _MultiChoiceTaskWidgetState extends State<MultiChoiceTaskWidget> {
  final Set<String> _selectedAnswers = {};

  bool get _isAnswered => widget.result != null;

  void _toggleAnswer(String answer) {
    if (_isAnswered) {
      return;
    }

    setState(() {
      if (_selectedAnswers.contains(answer)) {
        _selectedAnswers.remove(answer);
      } else {
        _selectedAnswers.add(answer);
      }
    });
  }

  void _confirmAnswer() {
    if (_isAnswered || _selectedAnswers.isEmpty) {
      return;
    }

    final result = widget.task.checkAnswer(_selectedAnswers.toList());

    widget.onTaskAnswered(result);
  }

  TaskAnswerState _getAnswerState(String answer) {
    final result = widget.result;

    if (result == null) {
      return TaskAnswerState.neutral;
    }

    final correctAnswers = result.correctAnswer ?? [];
    final selectedAnswers = result.selectedAnswer ?? [];

    if (correctAnswers.contains(answer)) {
      return TaskAnswerState.correct;
    }

    if (selectedAnswers.contains(answer)) {
      return TaskAnswerState.incorrect;
    }

    return TaskAnswerState.neutral;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.task.condition,
          style: AppTextStyles.headline,
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: AppSpacing.lg),

        Image.asset(
          widget.task.imagePath,
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),

        const SizedBox(height: AppSpacing.lg),

        ...widget.task.answers.map(
          (answer) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _MultiChoiceAnswerButton(
              answer: answer,
              state: _getAnswerState(answer),
              isSelected: _selectedAnswers.contains(answer),
              onPressed: _isAnswered ? null : () => _toggleAnswer(answer),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        FilledButton(
          onPressed: _isAnswered || _selectedAnswers.isEmpty
              ? null
              : _confirmAnswer,
          child: const Text('Підтвердити'),
        ),
      ],
    );
  }
}

class _MultiChoiceAnswerButton extends StatelessWidget {
  const _MultiChoiceAnswerButton({
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
    IconData icon;

    if (state == TaskAnswerState.correct) {
      icon = Icons.check_box;
    } else if (state == TaskAnswerState.incorrect) {
      icon = Icons.close;
    } else if (isSelected) {
      icon = Icons.check_box;
    } else {
      icon = Icons.check_box_outline_blank;
    }

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
}
