import 'evaluation/evaluation_result.dart';

class TopicAttemptResult {
  const TopicAttemptResult({
    required this.totalTasks,
    required this.completedTasks,
    required this.correctTasks,
    this.evaluation,
  });

  final int totalTasks;
  final int completedTasks;
  final int correctTasks;

  final EvaluationResult? evaluation;

  bool get isFinished => completedTasks == totalTasks;

  double get score {
    if (totalTasks == 0) {
      return 0;
    }

    return correctTasks / totalTasks;
  }
}
