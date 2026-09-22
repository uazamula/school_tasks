import 'package:flutter/foundation.dart';
import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_data/input_task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/approximate_equals_evaluator.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/tolerance_config.dart';

final List<TaskData> rational = [
  InputTaskData(
    prompt: TaskPrompt(content: [TextContent('Скільки буде 2 + 6?')]),
    correctAnswer: Rational(8),
    inputMode: InputMode.decimal,
    tolerance: ApproximateToleranceConfig(
      relativeTolerance: Rational(1, 1000),
      absoluteTolerance: Rational(1, 10000),
    ),
  ),

  InputTaskData(
    prompt: TaskPrompt(content: [TextContent('Введіть значення 2/4')]),
    correctAnswer: Rational(1, 2),
    inputMode: InputMode.decimal,
  ),

  InputTaskData(
    prompt: TaskPrompt(content: [TextContent('Введіть значення 1/3')]),
    correctAnswer: Rational(1, 3),
    inputMode: InputMode.decimal,
    tolerance: ApproximateToleranceConfig(
      relativeTolerance: Rational(1, 1000),
      absoluteTolerance: Rational(1, 10000),
    ),
  ),

  InputTaskData(
    prompt: TaskPrompt(content: [TextContent('Скільки буде 3 - 3?')]),
    correctAnswer: Rational(0),
    inputMode: InputMode.integer,
  ),
];

void _testRationalAndTolerance() {
  debugPrint('========== RATIONAL TESTS ==========');

  // --- Нормалізація ---

  final half = Rational(1, 2);
  final reducedHalf = Rational(2, 4);
  final negativeHalf = Rational(1, -2);
  final anotherNegativeHalf = Rational(-2, 4);
  final zero = Rational(0);

  debugPrint('1/2 -> $half');
  debugPrint('2/4 -> $reducedHalf');
  debugPrint('1/-2 -> $negativeHalf');
  debugPrint('-2/4 -> $anotherNegativeHalf');
  debugPrint('0 -> $zero');

  debugPrint('1/2 == 2/4: ${half == reducedHalf}');
  debugPrint('1/-2 == -2/4: ${negativeHalf == anotherNegativeHalf}');

  // --- Арифметика ---

  debugPrint('1/3 + 1/6 = ${Rational(1, 3) + Rational(1, 6)}');
  debugPrint('1/3 - 1/6 = ${Rational(1, 3) - Rational(1, 6)}');
  debugPrint('2/3 * 3/4 = ${Rational(2, 3) * Rational(3, 4)}');
  debugPrint('1/2 / 1/4 = ${Rational(1, 2) / Rational(1, 4)}');
  debugPrint('1/3 / 2/3 = ${Rational(1, 3) / Rational(2, 3)}');

  // --- Abs ---

  debugPrint('|-3/4| = ${Rational(-3, 4).abs}');
  debugPrint('|3/4| = ${Rational(3, 4).abs}');
  debugPrint('|0| = ${Rational(0).abs}');

  // --- Порівняння ---

  debugPrint('1/3 < 1/2: ${Rational(1, 3).compareTo(Rational(1, 2)) < 0}');

  debugPrint(
    '1/2 == 2/4: '
    '${Rational(1, 2).compareTo(Rational(2, 4)) == 0}',
  );

  debugPrint('2/3 > 1/2: ${Rational(2, 3).compareTo(Rational(1, 2)) > 0}');

  // --- Ділення на нуль ---

  try {
    final result = Rational(1) / Rational(0);
    debugPrint('1 / 0 = $result');
  } catch (e) {
    debugPrint('1 / 0 -> ERROR: $e');
  }

  debugPrint('========== EVALUATOR TESTS ==========');

  final evaluator = ApproximateEqualsEvaluator(
    relativeTolerance: Rational(1, 1000),
    absoluteTolerance: Rational(1, 2),
  );

  // 1. Точна відповідь.
  debugPrint(
    '5000.2 vs 5000.2: '
    '${evaluator.evaluate(Rational(25001, 5), Rational(25001, 5))}',
  );

  // 2. Абсолютна і відносна похибка проходять.
  debugPrint(
    '5000.2 vs 5000.3: '
    '${evaluator.evaluate(Rational(50003, 10), Rational(25001, 5))}',
  );

  // 3. Відносна проходить, абсолютна НЕ проходить.
  //
  // absolute error = 0.9
  // absolute tolerance = 0.5
  // relative error ≈ 0.00018
  // relative tolerance = 0.001
  //
  // Очікуємо false.
  debugPrint(
    '5001.1 vs 5000.2: '
    '${evaluator.evaluate(Rational(50011, 10), Rational(25001, 5))}',
  );

  // 4. Абсолютна проходить, відносна проходить.
  //
  // solution = 1
  // userAnswer = 1.0005
  // absolute error = 0.0005 <= 0.5
  // relative error = 0.0005 <= 0.001
  //
  // обидві проходять -> true.
  debugPrint(
    '1.0005 vs 1: '
    '${evaluator.evaluate(Rational(2001, 2000), Rational(1))}',
  );

  // 5. Абсолютна проходить, але відносна НЕ проходить.
  //
  // solution = 0.1
  // userAnswer = 0.1005
  // absolute error = 0.0005 <= 0.5
  // relative error = 0.005 > 0.001
  //
  // Очікуємо false.
  debugPrint(
    '0.1005 vs 0.1: '
    '${evaluator.evaluate(Rational(201, 2000), Rational(1, 10))}',
  );

  // 6. solution = 0.
  // Відносна похибка не перевіряється.
  // absolute error = 0.4 <= 0.5
  //
  // Очікуємо true.
  debugPrint(
    '0.4 vs 0: '
    '${evaluator.evaluate(Rational(2, 5), Rational(0))}',
  );

  // 7. solution = 0.
  // absolute error = 0.6 > 0.5
  //
  // Очікуємо false.
  debugPrint(
    '0.6 vs 0: '
    '${evaluator.evaluate(Rational(3, 5), Rational(0))}',
  );

  // 8. Обидві tolerance не проходять.
  debugPrint(
    '5020 vs 5000.2: '
    '${evaluator.evaluate(Rational(25100, 5), Rational(25001, 5))}',
  );

  debugPrint('========== END TESTS ==========');
}
