import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_snapshot.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_completion_reason.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';

class TopicResultUpdater {
  const TopicResultUpdater();

  TopicResult update({
    required TopicAttemptResult attempt,
    required DateTime currentAt,
    TopicResult? previous,
    TopicCompletionReason completionReason = TopicCompletionReason.completed,
    int failureCount = 0,
  }) {
    final isPassed = attempt.evaluation?.isPassed ?? false;

    // Незарахований результат завжди дорівнює 0.
    final currentScore = isPassed
        ? (attempt.evaluation?.finalScore ?? 0.0)
        : 0.0;

    final currentSnapshot = TopicAttemptSnapshot(
      completedAt: currentAt,
      duration: attempt.duration,
      completedTasks: attempt.completedTasks,
      totalTasks: attempt.totalTasks,
      accuracy: attempt.accuracy,
      score: currentScore,
      isPassed: isPassed,
      completionReason: completionReason,
      failureCount: failureCount,
      evaluation: attempt.evaluation,
    );

    // Перша спроба.
    if (previous == null) {
      return TopicResult(
        currentAttempt: currentSnapshot,
        bestAttempt: isPassed ? currentSnapshot : null,
      );
    }

    // Залишаємо попереднє правило визначення найкращого результату.
    final isNewBest = isPassed && currentScore > previous.bestScore;

    return TopicResult(
      currentAttempt: currentSnapshot,
      bestAttempt: isNewBest ? currentSnapshot : previous.bestAttempt,
    );
  }
}
