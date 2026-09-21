import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/input_keyboard.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';

class InputTaskWidget extends StatefulWidget {
  const InputTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.interactionScrollable,
    required this.onTaskAnswered,
  });

  final InputTask task;
  final TaskResult<int, int>? result;
  final bool interactionScrollable;
  final ValueChanged<TaskResult<int, int>> onTaskAnswered;

  @override
  State<InputTaskWidget> createState() => _InputTaskWidgetState();
}

class _InputTaskWidgetState extends State<InputTaskWidget> {
  String _input = '';

  bool get _isAnswered => widget.result != null;

  @override
  void didUpdateWidget(covariant InputTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      setState(() {
        _input = '';
      });
    }
  }

  void _onInputPressed(String value) {
    if (_isAnswered) {
      return;
    }

    setState(() {
      _input += value;
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

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
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
            color: _getInputBackgroundColor(colorScheme),
            border: Border.all(
              color: _getInputBorderColor(colorScheme),
              width: _isAnswered && widget.result!.isCorrect ? 3 : 2,
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
        InputKeyboard(
          mode: widget.task.inputMode,
          enabled: !_isAnswered,
          onInputPressed: _onInputPressed,
          onBackspacePressed: _onBackspacePressed,
        ),
      ],
    );

    final confirmation = FilledButton(
      onPressed: !_isAnswered && _input.isNotEmpty ? _onConfirmPressed : null,
      child: const Text('Підтвердити'),
    );

    return TaskInteractionLayout(
      scrollable: widget.interactionScrollable,
      content: content,
      confirmation: confirmation,
    );
  }

  Color _getInputBorderColor(ColorScheme colorScheme) {
    if (!_isAnswered) {
      return _input.isEmpty ? colorScheme.outline : colorScheme.primary;
    }

    return widget.result!.isCorrect ? Colors.green : colorScheme.error;
  }

  Color _getInputBackgroundColor(ColorScheme colorScheme) {
    if (!_isAnswered) {
      return colorScheme.surfaceContainerHighest;
    }

    if (widget.result!.isCorrect) {
      return colorScheme.brightness == Brightness.light
          ? const Color(0xFFC8E6C9)
          : const Color(0xFF356B3A);
    }

    return colorScheme.errorContainer;
  }
}
