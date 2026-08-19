import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';

class NumericKeyboard extends StatelessWidget {
  const NumericKeyboard({
    super.key,
    required this.enabled,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    required this.onConfirmPressed,
  });

  final bool enabled;
  final ValueChanged<int> onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onConfirmPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        childAspectRatio: 1.4,
        children: [
          for (var digit = 1; digit <= 9; digit++)
            _DigitButton(
              digit: digit,
              enabled: enabled,
              onPressed: onDigitPressed,
            ),

          _ActionButton(
            icon: Icons.backspace_outlined,
            enabled: enabled,
            onPressed: onBackspacePressed,
          ),

          _DigitButton(digit: 0, enabled: enabled, onPressed: onDigitPressed),

          _ActionButton(
            icon: Icons.check,
            enabled: enabled,
            onPressed: onConfirmPressed,
          ),
        ],
      ),
    );
  }
}

class _DigitButton extends StatelessWidget {
  const _DigitButton({
    required this.digit,
    required this.enabled,
    required this.onPressed,
  });

  final int digit;
  final bool enabled;
  final ValueChanged<int> onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: enabled ? () => onPressed(digit) : null,
      child: Text(digit.toString(), style: AppTextStyles.title),
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
