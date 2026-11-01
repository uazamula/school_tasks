import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';

/// Колбеки, якими віджети завдань повідомляють сторінку про події.
class TaskCallbacks {
  const TaskCallbacks({
    required this.onTaskAnswered,
    required this.onProgressStep,
    required this.onCorrectPair,
    required this.onIncorrectPair,
    required this.onIncorrectPairAttempt,
    required this.onMatchingAccuracyChanged,
    this.onCorrectSlotFilled,
    this.onElementReachedEdge,
  });

  /// Завдання повністю виконане.
  final ValueChanged<TaskResult<dynamic, dynamic>> onTaskAnswered;

  /// Один крок прогресу (правильно складена пара).
  final VoidCallback onProgressStep;

  /// Правильна спроба: пара або слот (звук вдачі).
  final VoidCallback onCorrectPair;

  /// Неправильна спроба: пара або слот (звук невдачі).
  final VoidCallback onIncorrectPair;

  /// Реєструє неправильну спробу; true — ліміт помилок вичерпано.
  final bool Function() onIncorrectPairAttempt;

  /// Змінилася точність Matching/SlotAssembly.
  final ValueChanged<AccuracyResult> onMatchingAccuracyChanged;

  /// Правильно заповнено слот; аргумент — кількість заповнених слотів.
  final ValueChanged<int>? onCorrectSlotFilled;

  /// Падаючий елемент досяг краю.
  final VoidCallback? onElementReachedEdge;
}
