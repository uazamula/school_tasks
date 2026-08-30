import 'solution_evaluator.dart';

class EqualsEvaluator<T> extends SolutionEvaluator<T, T> {
  const EqualsEvaluator();

  @override
  bool evaluate(T answer, T solution) {
    return answer == solution;
  }
}
