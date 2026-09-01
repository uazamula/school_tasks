import 'package:school_tasks/features/learning/data/generation/wrong_answer_generator.dart';

class ArithmeticGeneratorConfig {
  const ArithmeticGeneratorConfig({
    required this.minA,
    required this.maxA,
    required this.minB,
    required this.maxB,
    required this.minimumResult,
    required this.maximumResult,
    this.divisibilityA,
    this.divisibilityB,
    this.resultDivisibility,
    this.wrongAnswerMinimumResult,
    this.wrongAnswerMaximumResult,
    this.wrongAnswerDivisibility,
    this.wrongAnswerCount = 3,
    this.wrongAnswerStrategy = WrongAnswerStrategy.randomInRange,
  });

  final int minA;
  final int maxA;
  final int? divisibilityA;

  final int minB;
  final int maxB;
  final int? divisibilityB;

  final int minimumResult;
  final int maximumResult;
  final int? resultDivisibility;

  final int? wrongAnswerMinimumResult;
  final int? wrongAnswerMaximumResult;
  final int? wrongAnswerDivisibility;

  final int wrongAnswerCount;
  final WrongAnswerStrategy wrongAnswerStrategy;

  int get effectiveWrongAnswerMinimumResult =>
      wrongAnswerMinimumResult ?? minimumResult;

  int get effectiveWrongAnswerMaximumResult =>
      wrongAnswerMaximumResult ?? maximumResult;
}
