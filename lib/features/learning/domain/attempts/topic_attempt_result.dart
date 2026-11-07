import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_result.dart';

class TopicAttemptResult {
  const TopicAttemptResult({
    required this.totalTasks,
    required this.completedTasks,
    required this.accuracy,
    required this.duration,
    this.evaluation,
    this.streak,
    this.pairsCompleted,
  });

  /// Найкраща серія за спробу (лише для streak-тем).
  final int? streak;
  final int? pairsCompleted;

  final int totalTasks;
  final int completedTasks;
  final AccuracyResult accuracy;
  final Duration duration;

  final EvaluationResult? evaluation;

  bool get isFinished => completedTasks == totalTasks;

  double get score => accuracy.value;
}
