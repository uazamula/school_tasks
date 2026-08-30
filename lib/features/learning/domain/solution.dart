import 'solution_evaluator.dart';

class Solution<TAnswer, TSolution> {
  const Solution({required this.value, required this.evaluator});

  final TSolution value;
  final SolutionEvaluator<TAnswer, TSolution> evaluator;

  bool evaluate(TAnswer answer) {
    return evaluator.evaluate(answer, value);
  }
}
