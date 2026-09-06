import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';

class MatchingEvaluator
    extends SolutionEvaluator<MatchingAnswer, List<MatchingPair>> {
  const MatchingEvaluator();

  @override
  bool evaluate(MatchingAnswer answer, List<MatchingPair> solution) {
    return solution.any(
      (pair) => pair.left == answer.left && pair.right == answer.right,
    );
  }
}
