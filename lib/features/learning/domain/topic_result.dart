import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_snapshot.dart';

class TopicResult {
  const TopicResult({required this.currentAttempt, required this.bestAttempt});

  /// Остання спроба незалежно від того, чи зарахована тема.
  final TopicAttemptSnapshot currentAttempt;

  /// Найкраща зарахована спроба.
  ///
  /// null, якщо ще не було зарахованої спроби,
  /// яка встановила найкращий результат.
  final TopicAttemptSnapshot? bestAttempt;

  // Гетери для сумісності з наявними споживачами TopicResult.

  double get currentScore => currentAttempt.score;

  bool get currentIsPassed => currentAttempt.isPassed;

  DateTime get currentAt => currentAttempt.completedAt;

  Duration get currentDuration => currentAttempt.duration;

  double get bestScore => bestAttempt?.score ?? 0.0;

  DateTime? get bestAt => bestAttempt?.completedAt;

  Duration? get bestDuration => bestAttempt?.duration;

  Map<String, dynamic> toJson() {
    return {
      'currentAttempt': currentAttempt.toJson(),
      'bestAttempt': bestAttempt?.toJson(),
    };
  }

  factory TopicResult.fromJson(Map<String, dynamic> json) {
    final currentAttemptJson = Map<String, dynamic>.from(
      json['currentAttempt'] as Map,
    );

    final bestAttemptValue = json['bestAttempt'];

    return TopicResult(
      currentAttempt: TopicAttemptSnapshot.fromJson(currentAttemptJson),
      bestAttempt: bestAttemptValue == null
          ? null
          : TopicAttemptSnapshot.fromJson(
              Map<String, dynamic>.from(bestAttemptValue as Map),
            ),
    );
  }
}
