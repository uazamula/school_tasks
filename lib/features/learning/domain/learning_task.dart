import 'package:school_tasks/features/learning/domain/task_result.dart';

abstract class LearningTask {
  const LearningTask({required this.condition, required this.correctAnswer});

  final String condition;
  final int correctAnswer;

  TaskResult<int> checkAnswer(int answer);
}
