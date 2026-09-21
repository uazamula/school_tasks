import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

enum InputKeyboardKeyType { input, cycle, backspace, empty }

class InputKeyboardKey {
  const InputKeyboardKey.input(this.value)
    : type = InputKeyboardKeyType.input,
      values = null;

  const InputKeyboardKey.cycle(this.values)
    : type = InputKeyboardKeyType.cycle,
      value = null;

  const InputKeyboardKey.backspace()
    : type = InputKeyboardKeyType.backspace,
      value = null,
      values = null;

  const InputKeyboardKey.empty()
    : type = InputKeyboardKeyType.empty,
      value = null,
      values = null;

  final InputKeyboardKeyType type;
  final String? value;
  final List<String>? values;
}

class InputKeyboard extends StatelessWidget {
  const InputKeyboard({
    super.key,
    required this.mode,
    required this.enabled,
    required this.onInputPressed,
    required this.onCyclePressed,
    required this.onBackspacePressed,
  });

  final InputMode mode;
  final bool enabled;
  final ValueChanged<String> onInputPressed;
  final ValueChanged<List<String>> onCyclePressed;
  final VoidCallback onBackspacePressed;

  List<List<InputKeyboardKey>> _getLayout() {
    switch (mode) {
      case InputMode.integer:
        return [
          [
            const InputKeyboardKey.input('1'),
            const InputKeyboardKey.input('2'),
            const InputKeyboardKey.input('3'),
          ],
          [
            const InputKeyboardKey.input('4'),
            const InputKeyboardKey.input('5'),
            const InputKeyboardKey.input('6'),
          ],
          [
            const InputKeyboardKey.input('7'),
            const InputKeyboardKey.input('8'),
            const InputKeyboardKey.input('9'),
          ],
          [
            const InputKeyboardKey.backspace(),
            const InputKeyboardKey.input('0'),
            const InputKeyboardKey.empty(),
          ],
        ];

      case InputMode.decimal:
        return [
          [
            const InputKeyboardKey.input('1'),
            const InputKeyboardKey.input('2'),
            const InputKeyboardKey.input('3'),
          ],
          [
            const InputKeyboardKey.input('4'),
            const InputKeyboardKey.input('5'),
            const InputKeyboardKey.input('6'),
          ],
          [
            const InputKeyboardKey.input('7'),
            const InputKeyboardKey.input('8'),
            const InputKeyboardKey.input('9'),
          ],
          [
            const InputKeyboardKey.backspace(),
            const InputKeyboardKey.input('0'),
            const InputKeyboardKey.cycle(['.']),
          ],
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final rows = _getLayout();

    return SizedBox(
      width: 240,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in rows) ...[
            if (row != rows.first) const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  for (var index = 0; index < row.length; index++) ...[
                    if (index > 0) const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildKey(row[index])),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKey(InputKeyboardKey key) {
    switch (key.type) {
      case InputKeyboardKeyType.input:
        return _InputButton(
          value: key.value!,
          enabled: enabled,
          onPressed: onInputPressed,
        );
      case InputKeyboardKeyType.cycle:
        return _CycleButton(
          values: key.values!,
          enabled: enabled,
          onPressed: () => onCyclePressed(key.values!),
        );

      case InputKeyboardKeyType.backspace:
        return _ActionButton(
          icon: Icons.backspace_outlined,
          enabled: enabled,
          onPressed: onBackspacePressed,
        );

      case InputKeyboardKeyType.empty:
        return const SizedBox.expand();
    }
  }
}

class _InputButton extends StatelessWidget {
  const _InputButton({
    required this.value,
    required this.enabled,
    required this.onPressed,
  });

  final String value;
  final bool enabled;
  final ValueChanged<String> onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? () => onPressed(value) : null,
      child: Text(value, style: AppTextStyles.title),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.enabled,
    required this.onPressed,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      child: Icon(icon),
    );
  }
}

class _CycleButton extends StatelessWidget {
  const _CycleButton({
    required this.values,
    required this.enabled,
    required this.onPressed,
  });

  final List<String> values;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? onPressed : null,
      child: Text(values.join(' / '), style: AppTextStyles.title),
    );
  }
}
