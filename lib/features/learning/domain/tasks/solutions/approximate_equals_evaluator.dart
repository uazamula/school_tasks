import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';

class ApproximateEqualsEvaluator extends SolutionEvaluator<Rational, Rational> {
  const ApproximateEqualsEvaluator({
    required this.relativeTolerance,
    required this.absoluteTolerance,
  });

  final Rational relativeTolerance;
  final Rational absoluteTolerance;

  @override
  bool evaluate(Rational userAnswer, Rational solution) {
    final absoluteError = (userAnswer - solution).abs;

    final absolutePass = absoluteError.compareTo(absoluteTolerance) <= 0;

    if (!absolutePass) {
      return false;
    }

    if (solution == Rational(0)) {
      return true;
    }

    final relativeError = absoluteError / solution.abs;

    return relativeError.compareTo(relativeTolerance) <= 0;
  }
}
