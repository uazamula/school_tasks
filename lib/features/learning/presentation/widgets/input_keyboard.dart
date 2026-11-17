import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';

enum InputKeyboardKeyType { input, cycle, decimalSeparator, backspace, empty }

class InputKeyboardKey {
  const InputKeyboardKey.input(this.value)
    : type = InputKeyboardKeyType.input,
      values = null;

  const InputKeyboardKey.cycle(this.values)
    : type = InputKeyboardKeyType.cycle,
      value = null;

  const InputKeyboardKey.decimalSeparator()
    : type = InputKeyboardKeyType.decimalSeparator,
      value = null,
      values = null;

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
    required this.decimalSeparator,
    required this.onInputPressed,
    required this.onCyclePressed,
    required this.onDecimalSeparatorPressed,
    required this.onBackspacePressed,
  });

  final InputMode mode;
  final bool enabled;
  final String decimalSeparator;

  final ValueChanged<String> onInputPressed;
  final ValueChanged<List<String>> onCyclePressed;
  final VoidCallback onDecimalSeparatorPressed;
  final VoidCallback onBackspacePressed;

  static const double _width = 240;
  static const double _keyHeight = 48;

  // Цифри 1–9 однакові для всіх режимів.
  static const _digitRows = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
  ];

  List<List<InputKeyboardKey>> _getLayout() {
    // Режими відрізняються лише останньою клавішею нижнього рядка.
    final lastKey = switch (mode) {
      InputMode.integer => const InputKeyboardKey.empty(),
      InputMode.decimal => const InputKeyboardKey.decimalSeparator(),
    };

    return [
      for (final row in _digitRows)
        [for (final digit in row) InputKeyboardKey.input(digit)],
      [
        const InputKeyboardKey.backspace(),
        const InputKeyboardKey.input('0'),
        lastKey,
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final rows = _getLayout();

    return SizedBox(
      width: _width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var r = 0; r < rows.length; r++) ...[
            if (r > 0) const SizedBox(height: AppSpacing.sm),
            SizedBox(
              height: _keyHeight,
              child: Row(
                children: [
                  for (var c = 0; c < rows[r].length; c++) ...[
                    if (c > 0) const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _buildKey(rows[r][c])),
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
    return switch (key.type) {
      InputKeyboardKeyType.input => _KeyButton(
        enabled: enabled,
        onPressed: () => onInputPressed(key.value!),
        child: Text(key.value!, style: AppTextStyles.title),
      ),
      InputKeyboardKeyType.cycle => _KeyButton(
        enabled: enabled,
        onPressed: () => onCyclePressed(key.values!),
        child: Text(key.values!.join(' / '), style: AppTextStyles.title),
      ),
      InputKeyboardKeyType.decimalSeparator => _KeyButton(
        enabled: enabled,
        onPressed: onDecimalSeparatorPressed,
        child: Text(decimalSeparator, style: AppTextStyles.title),
      ),
      InputKeyboardKeyType.backspace => _KeyButton(
        enabled: enabled,
        onPressed: onBackspacePressed,
        child: const Icon(Icons.backspace_outlined),
      ),
      InputKeyboardKeyType.empty => const SizedBox.expand(),
    };
  }
}

/// Єдина кнопка клавіатури: вигляд задає [child], а вимкнений стан
/// (enabled == false) прибирає обробник натискання.
class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.enabled,
    required this.onPressed,
    required this.child,
  });

  final bool enabled;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FilledButton(onPressed: enabled ? onPressed : null, child: child);
  }
}
