import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';

class FractionEvaluator implements SolutionEvaluator<Set<int>, int> {
  const FractionEvaluator();

  @override
  bool evaluate(Set<int> answer, int requiredParts) {
    return answer.length == requiredParts;
  }
}
