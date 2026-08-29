import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';

class AdditionGeneratorConfig {
  const AdditionGeneratorConfig({
    required this.minA,
    required this.maxA,
    required this.minB,
    required this.maxB,
    required this.minimumResult,
    required this.maximumResult,
    this.wrongAnswerMinimumResult,
    this.wrongAnswerMaximumResult,
    this.wrongAnswerCount = 3,
    this.wrongAnswerStrategy = WrongAnswerStrategy.randomInRange,
  });

  final int minA;
  final int maxA;

  final int minB;
  final int maxB;

  /// Допустимий діапазон правильних відповідей.
  final int minimumResult;
  final int maximumResult;

  /// Допустимий діапазон неправильних відповідей.
  ///
  /// Якщо не заданий, використовується діапазон правильних відповідей.
  final int? wrongAnswerMinimumResult;
  final int? wrongAnswerMaximumResult;

  final int wrongAnswerCount;

  final WrongAnswerStrategy wrongAnswerStrategy;

  int get effectiveWrongAnswerMinimumResult =>
      wrongAnswerMinimumResult ?? minimumResult;

  int get effectiveWrongAnswerMaximumResult =>
      wrongAnswerMaximumResult ?? maximumResult;
}
