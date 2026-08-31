import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_criterion.dart';
import 'package:school_tasks/features/learning/domain/evaluation/criterion_evaluation_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_criterion_type.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/time_criterion.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';

class EvaluationCalculator {
  const EvaluationCalculator();

  EvaluationResult calculate({
    required Topic topic,
    required TopicAttemptResult result,
    Duration? elapsedTime,
  }) {
    final criterionResults =
        <EvaluationCriterionType, CriterionEvaluationResult>{};

    final accuracyResult = const AccuracyCriterion().calculate(result);

    _addCriterionResult(
      criterionResults: criterionResults,
      criterion: EvaluationCriterionType.accuracy,
      measurement: accuracyResult.measurement,
      score: accuracyResult.score,
      configuredWeight:
          topic.evaluation.weights[EvaluationCriterionType.accuracy] ?? 0,
    );

    final timeConfig = topic.evaluation.time;

    if (elapsedTime != null &&
        topic.evaluation.weights.containsKey(EvaluationCriterionType.time) &&
        timeConfig != null) {
      final timeResult = TimeCriterion(
        targetTime: timeConfig.targetTime,
        maximumTime: timeConfig.maximumTime,
      ).calculate(elapsedTime);

      _addCriterionResult(
        criterionResults: criterionResults,
        criterion: EvaluationCriterionType.time,
        measurement: timeResult.measurement,
        score: timeResult.score,
        configuredWeight:
            topic.evaluation.weights[EvaluationCriterionType.time] ?? 0,
      );
    }

    final availableWeight = criterionResults.values.fold(
      0.0,
      (sum, result) => sum + result.weight,
    );

    if (availableWeight <= 0) {
      return EvaluationResult(
        criterionResults: const {},
        finalScore: 0,
        isPassed: _isPassed(topic: topic, result: result),
      );
    }
    final normalizedResults =
        <EvaluationCriterionType, CriterionEvaluationResult>{};

    var finalScore = 0.0;

    for (final entry in criterionResults.entries) {
      final result = entry.value;

      final normalizedWeight = result.weight / availableWeight;
      final weightedScore = result.score * normalizedWeight;

      normalizedResults[entry.key] = CriterionEvaluationResult(
        criterion: result.criterion,
        measurement: result.measurement,
        score: result.score,
        weight: normalizedWeight,
        weightedScore: weightedScore,
      );

      finalScore += weightedScore;
    }

    final isPassed = _isPassed(topic: topic, result: result);

    return EvaluationResult(
      criterionResults: Map.unmodifiable(normalizedResults),
      finalScore: finalScore,
      isPassed: isPassed,
    );
  }

  void _addCriterionResult({
    required Map<EvaluationCriterionType, CriterionEvaluationResult>
    criterionResults,
    required EvaluationCriterionType criterion,
    required double measurement,
    required double score,
    required double configuredWeight,
  }) {
    if (configuredWeight <= 0) {
      return;
    }

    criterionResults[criterion] = CriterionEvaluationResult(
      criterion: criterion,
      measurement: measurement,
      score: score,
      weight: configuredWeight,
      weightedScore: 0,
    );
  }

  bool _isPassed({required Topic topic, required TopicAttemptResult result}) {
    final criteria = topic.passingCriteria;

    if (criteria == null) {
      return true;
    }

    final minimumAccuracy = criteria.minimumAccuracy;

    if (minimumAccuracy != null && result.score < minimumAccuracy) {
      return false;
    }

    return true;
  }
}
