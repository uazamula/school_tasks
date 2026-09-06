import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/criterion_result.dart';

class AccuracyCriterion {
  const AccuracyCriterion();

  CriterionResult calculate(TopicAttemptResult result) {
    final accuracy = result.accuracy.value;

    return CriterionResult(measurement: accuracy, score: accuracy);
  }
}
