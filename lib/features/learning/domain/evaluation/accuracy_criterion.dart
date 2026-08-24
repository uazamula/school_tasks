import '../topic_attempt_result.dart';
import 'criterion_result.dart';

class AccuracyCriterion {
  const AccuracyCriterion();

  CriterionResult calculate(TopicAttemptResult result) {
    if (result.totalTasks == 0) {
      return const CriterionResult(measurement: 0, score: 0);
    }

    final accuracy = result.correctTasks / result.totalTasks;

    return CriterionResult(measurement: accuracy, score: accuracy);
  }
}
