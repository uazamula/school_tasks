import 'criterion_evaluation_result.dart';
import 'evaluation_criterion_type.dart';

class EvaluationResult {
  const EvaluationResult({
    required this.criterionResults,
    required this.finalScore,
    required this.isPassed,
  });

  final Map<EvaluationCriterionType, CriterionEvaluationResult>
  criterionResults;

  /// Підсумкова оцінка від 0 до 1.
  final double finalScore;

  /// Чи виконані умови зарахування теми.
  final bool isPassed;
}
