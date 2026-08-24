import '../topic.dart';
import '../topic_attempt_result.dart';
import 'accuracy_criterion.dart';
import 'evaluation_criterion_type.dart';
import 'time_criterion.dart';

class EvaluationCalculator {
  const EvaluationCalculator();

  double calculate({
    required Topic topic,
    required TopicAttemptResult result,
    Duration? elapsedTime,
  }) {
    final criterionResults = <EvaluationCriterionType, double>{};

    final accuracyResult = const AccuracyCriterion().calculate(result);

    criterionResults[EvaluationCriterionType.accuracy] = accuracyResult.score;

    final timeConfig = topic.evaluation.time;

    if (elapsedTime != null &&
        topic.evaluation.weights.containsKey(EvaluationCriterionType.time) &&
        timeConfig != null) {
      final timeResult = TimeCriterion(
        targetTime: timeConfig.targetTime,
        maximumTime: timeConfig.maximumTime,
      ).calculate(elapsedTime);

      criterionResults[EvaluationCriterionType.time] = timeResult.score;
    }

    if (criterionResults.isEmpty) {
      return 0;
    }

    final availableWeight = criterionResults.keys.fold(
      0.0,
      (sum, type) => sum + (topic.evaluation.weights[type] ?? 0),
    );

    if (availableWeight <= 0) {
      return 0;
    }

    var finalScore = 0.0;

    for (final entry in criterionResults.entries) {
      final weight = topic.evaluation.weights[entry.key] ?? 0;
      final normalizedWeight = weight / availableWeight;

      finalScore += entry.value * normalizedWeight;
    }

    return finalScore;
  }
}
