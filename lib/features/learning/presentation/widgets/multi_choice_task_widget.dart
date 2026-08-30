import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../domain/multi_choice_task.dart';
import '../../domain/task_result.dart';
import 'multi_choice_answers.dart';
import 'task_prompt_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: widget.task.prompt),

        const SizedBox(height: AppSpacing.lg),

        MultiChoiceAnswers(
          answers: widget.task.answers,
          selectedAnswers: _selectedAnswers,
          result: widget.result,
          onAnswerSelected: _toggleAnswer,
          enabled: !_isAnswered,
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
