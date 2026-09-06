import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';

class TaskResult<TAnswer, TSolution> {
  const TaskResult({
    required this.state,
    this.selectedAnswer,
    this.solution,
    this.accuracy,
  });

  final TaskAnswerState state;
  final TAnswer? selectedAnswer;
  final Solution<TAnswer, TSolution>? solution;

  /// Спеціальний результат точності.
  ///
  /// Використовується для завдань, у яких одна відповідь
  /// складається з кількох окремих елементів.
  ///
  /// Для звичайних завдань залишається null, і тоді
  /// їхній внесок у точність визначається як 1/1 або 0/1.
  final AccuracyResult? accuracy;

  bool get isAnswered => state != TaskAnswerState.neutral;

  bool get isCorrect => state == TaskAnswerState.correct;

  bool get isIncorrect => state == TaskAnswerState.incorrect;
}
