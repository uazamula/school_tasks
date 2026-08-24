import '../topic.dart';
import '../topic_attempt_result.dart';
import 'accuracy_criterion.dart';
import 'evaluation_criterion_type.dart';

class EvaluationCalculator {
  const EvaluationCalculator();

  double calculate({required Topic topic, required TopicAttemptResult result}) {
    final accuracyResult = const AccuracyCriterion().calculate(result);

    final accuracyWeight = topic.evaluation.normalizedWeight(
      EvaluationCriterionType.accuracy,
    );

    return accuracyResult.score * accuracyWeight;
  }
}
