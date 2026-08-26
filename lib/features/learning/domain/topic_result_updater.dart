import 'topic_attempt_result.dart';
import 'topic_result.dart';

class TopicResultUpdater {
  const TopicResultUpdater();

  TopicResult update({
    required TopicAttemptResult attempt,
    required DateTime currentAt,
    TopicResult? previous,
  }) {
    final isPassed = attempt.evaluation?.isPassed ?? false;

    // За нашою домовленістю незарахований результат завжди дорівнює 0.
    final currentScore = isPassed
        ? (attempt.evaluation?.finalScore ?? 0.0)
        : 0.0;

    // Перша спроба.
    if (previous == null) {
      return TopicResult(
        currentScore: currentScore,
        currentIsPassed: isPassed,
        currentAt: currentAt,
        currentDuration: attempt.duration,
        bestScore: isPassed ? currentScore : 0.0,
        bestAt: isPassed ? currentAt : null,
        bestDuration: isPassed ? attempt.duration : null,
      );
    }

    // Нова спроба стає найкращою тільки якщо вона зарахована
    // і має кращий результат, ніж попередній найкращий.
    final isNewBest = isPassed && currentScore > previous.bestScore;

    return TopicResult(
      currentScore: currentScore,
      currentIsPassed: isPassed,
      currentAt: currentAt,
      currentDuration: attempt.duration,
      bestScore: isNewBest ? currentScore : previous.bestScore,
      bestAt: isNewBest ? currentAt : previous.bestAt,
      bestDuration: isNewBest ? attempt.duration : previous.bestDuration,
    );
  }
}
