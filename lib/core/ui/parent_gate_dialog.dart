import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/presentation/widgets/input_keyboard.dart';

/// Показує батьківський контроль. Повертає true, якщо відповідь правильна.
/// Тап поза діалогом закриває його (false).
Future<bool> showParentGate(BuildContext context) async {
  final passed = await showDialog<bool>(
    context: context,
    builder: (_) => const ParentGateDialog(),
  );

  return passed == true;
}

/// Задача на множення, яка складна для дошкільняти.
class ParentGateTask {
  const ParentGateTask(this.a, this.b);

  final int a;
  final int b;

  int get answer => a * b;

  static const _words = {6: 'шість', 7: 'сім', 8: 'вісім', 9: 'дев\'ять'};

  /// Текст словами, щоб задачу не можна було вгадати за цифрами.
  String get question => 'Результат множення:\n${_words[a]} на ${_words[b]}';

  factory ParentGateTask.random(Random random) {
    return ParentGateTask(6 + random.nextInt(4), 6 + random.nextInt(4));
  }
}

class ParentGateDialog extends StatefulWidget {
  const ParentGateDialog({super.key});

  @override
  State<ParentGateDialog> createState() => _ParentGateDialogState();
}

class _ParentGateDialogState extends State<ParentGateDialog>
    with SingleTickerProviderStateMixin {
  static const int _maxDigits = 2;

  final Random _random = Random();

  late ParentGateTask _task = ParentGateTask.random(_random);
  String _input = '';

  // Коротка «тряска» поля при неправильній відповіді.
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  void _onDigit(String digit) {
    if (_input.length >= _maxDigits) return;

    setState(() => _input += digit);
  }

  void _onBackspace() {
    if (_input.isEmpty) return;

    setState(() => _input = _input.substring(0, _input.length - 1));
  }

  void _onSubmit() {
    if (_input.isEmpty) return;

    if (int.parse(_input) == _task.answer) {
      Navigator.of(context).pop(true);
      return;
    }

    // Неправильно: тряска, очищення, нова задача.
    _shake.forward(from: 0);
    setState(() {
      _input = '';
      _task = ParentGateTask.random(_random);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _task.question,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _shake,
              builder: (context, child) {
                final t = _shake.value;
                final dx = sin(t * pi * 6) * 12 * (1 - t);

                return Transform.translate(offset: Offset(dx, 0), child: child);
              },
              child: Container(
                width: 240,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _input,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            const SizedBox(height: 16),
            InputKeyboard(
              mode: InputMode.integer,
              enabled: true,
              decimalSeparator: ',',
              onInputPressed: _onDigit,
              onCyclePressed: (_) {},
              onDecimalSeparatorPressed: () {},
              onBackspacePressed: _onBackspace,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 240,
              child: FilledButton(
                onPressed: _input.isEmpty ? null : _onSubmit,
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
