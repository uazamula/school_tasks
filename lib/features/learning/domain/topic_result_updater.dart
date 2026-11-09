import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_snapshot.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_completion_reason.dart';
import 'package:school_tasks/features/learning/domain/topic_result.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';

class TopicResultUpdater {
  const TopicResultUpdater();

  TopicResult update({
    required TopicAttemptResult attempt,
    required DateTime currentAt,
    TopicResult? previous,
    TopicCompletionReason completionReason = TopicCompletionReason.completed,
    int failureCount = 0,
  }) {
    if (attempt.kind == TopicResultKind.streak) {
      return _updateStreak(
        attempt: attempt,
        streak: attempt.streak ?? 0,
        currentAt: currentAt,
        previous: previous,
        completionReason: completionReason,
        failureCount: failureCount,
      );
    }

    // Результат іншого виду (тему перемкнули) не порівнюємо.
    final comparable = previous?.kind == TopicResultKind.grade
        ? previous
        : null;

    final isPassed = attempt.evaluation?.isPassed ?? false;

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
      streak: attempt.streak,
      pairsCompleted: attempt.pairsCompleted,
    );

    if (comparable == null) {
      return TopicResult(
        currentAttempt: currentSnapshot,
        bestAttempt: isPassed ? currentSnapshot : null,
      );
    }

    final isNewBest = isPassed && currentScore > comparable.bestScore;

    return TopicResult(
      currentAttempt: currentSnapshot,
      bestAttempt: isNewBest ? currentSnapshot : comparable.bestAttempt,
    );
  }

  TopicResult _updateStreak({
    required TopicAttemptResult attempt,
    required int streak,
    required DateTime currentAt,
    required TopicResult? previous,
    required TopicCompletionReason completionReason,
    required int failureCount,
  }) {
    final snapshot = TopicAttemptSnapshot(
      completedAt: currentAt,
      duration: attempt.duration,
      completedTasks: attempt.completedTasks,
      totalTasks: attempt.totalTasks,
      accuracy: attempt.accuracy,
      score: 0,
      isPassed: true,
      completionReason: completionReason,
      failureCount: failureCount,
      kind: TopicResultKind.streak,
      streak: streak,
      pairsCompleted: attempt.pairsCompleted ?? 0,
    );

    final comparable = previous?.kind == TopicResultKind.streak
        ? previous
        : null;

    final best = comparable?.bestAttempt;
    final isNewBest = best == null || streak > (best.streak ?? 0);

    return TopicResult(
      currentAttempt: snapshot,
      bestAttempt: isNewBest ? snapshot : best,
    );
  }
}
