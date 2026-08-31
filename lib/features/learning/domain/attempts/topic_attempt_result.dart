import 'package:school_tasks/features/learning/domain/evaluation/evaluation_result.dart';

class TopicAttemptResult {
  const TopicAttemptResult({
    required this.totalTasks,
    required this.completedTasks,
    required this.correctTasks,
    required this.duration,
    this.evaluation,
  });

  final int totalTasks;
  final int completedTasks;
  final int correctTasks;
  final Duration duration;

  final EvaluationResult? evaluation;

  bool get isFinished => completedTasks == totalTasks;

  double get score {
    if (totalTasks == 0) {
      return 0;
    }

    return correctTasks / totalTasks;
  }
}
