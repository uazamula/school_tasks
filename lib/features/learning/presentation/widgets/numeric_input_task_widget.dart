import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/numeric_input_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/numeric_keyboard.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class NumericInputTaskWidget extends StatefulWidget {
  const NumericInputTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final NumericInputTask task;
  final TaskResult<int, int>? result;
  final ValueChanged<TaskResult<int, int>> onTaskAnswered;

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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: widget.task.prompt),

        const SizedBox(height: AppSpacing.xl),

        AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 200,
          constraints: const BoxConstraints(minHeight: 72),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            border: Border.all(
              color: _input.isEmpty ? colorScheme.outline : colorScheme.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _input.isEmpty ? '—' : _input,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

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
