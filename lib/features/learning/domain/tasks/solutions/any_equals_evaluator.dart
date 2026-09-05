import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';

class AnyEqualsEvaluator<T> extends SolutionEvaluator<List<T>, List<T>> {
  const AnyEqualsEvaluator();

  @override
  bool evaluate(List<T> answer, List<T> solution) {
    if (answer.length != 1) {
      return false;
    }

    return solution.contains(answer.single);
  }
}
