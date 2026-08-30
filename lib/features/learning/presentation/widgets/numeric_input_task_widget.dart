import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/numeric_input_task.dart';
import '../../domain/task_result.dart';
import 'numeric_keyboard.dart';
import 'task_prompt_widget.dart';

class NumericInputTaskWidget extends StatefulWidget {
  const NumericInputTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final NumericInputTask task;
  final TaskResult<int>? result;
  final ValueChanged<TaskResult<int>> onTaskAnswered;

  @override
  State<NumericInputTaskWidget> createState() => _NumericInputTaskWidgetState();
}

class _NumericInputTaskWidgetState extends State<NumericInputTaskWidget> {
  String _input = '';

  bool get _isAnswered => widget.result != null;

  @override
  void didUpdateWidget(covariant NumericInputTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      setState(() {
        _input = '';
      });
    }
  }

  void _onDigitPressed(int digit) {
    if (_isAnswered) {
      return;
    }

    setState(() {
      _input += digit.toString();
    });
  }

  void _onBackspacePressed() {
    if (_isAnswered || _input.isEmpty) {
      return;
    }

    setState(() {
      _input = _input.substring(0, _input.length - 1);
    });
  }

  void _onConfirmPressed() {
    if (_isAnswered || _input.isEmpty) {
      return;
    }

    final answer = int.parse(_input);

    widget.onTaskAnswered(widget.task.checkAnswer(answer));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: widget.task.prompt),

        const SizedBox(height: AppSpacing.lg),

        Container(
          width: 180,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _input.isEmpty ? '—' : _input,
            style: AppTextStyles.headline,
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        NumericKeyboard(
          enabled: !_isAnswered,
          onDigitPressed: _onDigitPressed,
          onBackspacePressed: _onBackspacePressed,
          onConfirmPressed: _onConfirmPressed,
        ),
      ],
    );
  }
}
