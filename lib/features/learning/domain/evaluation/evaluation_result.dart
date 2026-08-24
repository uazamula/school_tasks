import 'criterion_evaluation_result.dart';
import 'evaluation_criterion_type.dart';

class EvaluationResult {
  const EvaluationResult({
    required this.criterionResults,
    required this.finalScore,
  });

  final Map<EvaluationCriterionType, CriterionEvaluationResult>
  criterionResults;

  /// Підсумкова оцінка від 0 до 1.
  final double finalScore;
}
