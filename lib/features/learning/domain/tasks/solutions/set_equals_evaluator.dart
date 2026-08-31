import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';

class SetEqualsEvaluator<T> extends SolutionEvaluator<List<T>, List<T>> {
  const SetEqualsEvaluator();

  @override
  bool evaluate(List<T> answer, List<T> solution) {
    final actual = Set<T>.from(answer);
    final expected = Set<T>.from(solution);

    return actual.length == expected.length && actual.containsAll(expected);
  }
}
