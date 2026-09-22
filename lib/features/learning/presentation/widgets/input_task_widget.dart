import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/input_parser.dart';
import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
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
  final TaskResult<Rational, Rational>? result;
  final bool interactionScrollable;
  final ValueChanged<TaskResult<Rational, Rational>> onTaskAnswered;

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

  void _onDecimalSeparatorPressed() {
    if (_isAnswered || _input.contains('.')) {
      return;
    }

    setState(() {
      _input += _input.isEmpty ? '0.' : '.';
    });
  }

  void _onConfirmPressed() {
    if (_isAnswered || _input.isEmpty) {
      return;
    }

    final answer = InputParser.parse(_input, widget.task.inputMode);

    widget.onTaskAnswered(widget.task.checkAnswer(answer));
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (_isAnswered || event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    final digit = _getDigit(key);

    if (digit != null) {
      _onInputPressed(digit);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.backspace) {
      _onBackspacePressed();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.numpadEnter) {
      _onConfirmPressed();
      return KeyEventResult.handled;
    }

    if (widget.task.inputMode == InputMode.decimal &&
        (key == LogicalKeyboardKey.period ||
            key == LogicalKeyboardKey.comma ||
            key == LogicalKeyboardKey.numpadDecimal)) {
      _onDecimalSeparatorPressed();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  String? _getDigit(LogicalKeyboardKey key) {
    final digits = <LogicalKeyboardKey, String>{
      LogicalKeyboardKey.digit0: '0',
      LogicalKeyboardKey.digit1: '1',
      LogicalKeyboardKey.digit2: '2',
      LogicalKeyboardKey.digit3: '3',
      LogicalKeyboardKey.digit4: '4',
      LogicalKeyboardKey.digit5: '5',
      LogicalKeyboardKey.digit6: '6',
      LogicalKeyboardKey.digit7: '7',
      LogicalKeyboardKey.digit8: '8',
      LogicalKeyboardKey.digit9: '9',
      LogicalKeyboardKey.numpad0: '0',
      LogicalKeyboardKey.numpad1: '1',
      LogicalKeyboardKey.numpad2: '2',
      LogicalKeyboardKey.numpad3: '3',
      LogicalKeyboardKey.numpad4: '4',
      LogicalKeyboardKey.numpad5: '5',
      LogicalKeyboardKey.numpad6: '6',
      LogicalKeyboardKey.numpad7: '7',
      LogicalKeyboardKey.numpad8: '8',
      LogicalKeyboardKey.numpad9: '9',
    };

    return digits[key];
  }

  String _getDecimalSeparator(Locale locale) {
    switch (locale.languageCode) {
      case 'uk':
      case 'tr':
        return ',';

      case 'en':
      default:
        return '.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final locale = Localizations.localeOf(context);
    final decimalSeparator = _getDecimalSeparator(locale);

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
            _input.isEmpty ? '—' : _input.replaceAll('.', decimalSeparator),
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
          decimalSeparator: decimalSeparator,
          onInputPressed: _onInputPressed,
          onCyclePressed: _onCyclePressed,
          onDecimalSeparatorPressed: _onDecimalSeparatorPressed,
          onBackspacePressed: _onBackspacePressed,
        ),
      ],
    );

    final confirmation = FilledButton(
      onPressed: !_isAnswered && _input.isNotEmpty ? _onConfirmPressed : null,
      child: const Text('Підтвердити'),
    );

    final interaction = TaskInteractionLayout(
      scrollable: widget.interactionScrollable,
      content: content,
      confirmation: confirmation,
    );

    return Focus(autofocus: true, onKeyEvent: _onKeyEvent, child: interaction);
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

  void _onCyclePressed(List<String> values) {
    if (_isAnswered || values.isEmpty || _input.isEmpty) {
      return;
    }

    final lastCharacter = _input.substring(_input.length - 1);
    final currentIndex = values.indexOf(lastCharacter);

    setState(() {
      if (currentIndex == -1) {
        _input += values.first;
        return;
      }

      final nextIndex = (currentIndex + 1) % values.length;

      _input = _input.substring(0, _input.length - 1) + values[nextIndex];
    });
  }
}
