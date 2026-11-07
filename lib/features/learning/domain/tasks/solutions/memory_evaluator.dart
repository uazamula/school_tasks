import 'package:school_tasks/features/learning/domain/tasks/content/memory_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/solutions/solution_evaluator.dart';

class MemoryEvaluator
    extends SolutionEvaluator<MemoryAnswer, List<MemoryPair>> {
  const MemoryEvaluator();

  @override
  bool evaluate(MemoryAnswer answer, List<MemoryPair> solution) {
    return answer.hiddenPairId == answer.facePairId &&
        solution.any((pair) => pair.id == answer.hiddenPairId);
  }
}
