import 'criterion_result.dart';

class TimeCriterion {
  const TimeCriterion({required this.targetTime, required this.maximumTime});

  /// Час, за який виконання вважається оптимальним.
  final Duration targetTime;

  /// Час, після якого оцінка стає 0.
  final Duration maximumTime;

  CriterionResult calculate(Duration elapsedTime) {
    if (elapsedTime <= targetTime) {
      return const CriterionResult(measurement: 0, score: 1);
    }

    if (elapsedTime >= maximumTime) {
      return CriterionResult(
        measurement: elapsedTime.inMilliseconds / 1000,
        score: 0,
      );
    }

    final elapsedAfterTarget = elapsedTime - targetTime;

    final availableTime = maximumTime - targetTime;

    final score =
        1 - elapsedAfterTarget.inMilliseconds / availableTime.inMilliseconds;

    return CriterionResult(
      measurement: elapsedTime.inMilliseconds / 1000,
      score: score.clamp(0.0, 1.0),
    );
  }
}
