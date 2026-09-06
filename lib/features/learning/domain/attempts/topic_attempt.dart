import 'package:school_tasks/features/learning/domain/attempts/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';

class TopicAttempt {
  TopicAttempt({required List<AttemptTask<dynamic, dynamic>> tasks})
    : tasks = List.unmodifiable(tasks);

  final List<AttemptTask<dynamic, dynamic>> tasks;

  int currentTaskIndex = 0;

  AttemptTask<dynamic, dynamic> get currentTask => tasks[currentTaskIndex];

  bool get isFinished => tasks.every((task) => task.isAnswered);

  int get completedTasks => tasks.where((task) => task.isAnswered).length;

  void recordResult(TaskResult<dynamic, dynamic> result) {
    currentTask.result = result;
  }

  bool moveToNextTask() {
    if (currentTaskIndex >= tasks.length - 1) {
      return false;
    }

    currentTaskIndex++;
    return true;
  }

  TopicAttemptResult getResult({required Duration duration}) {
    final completedTasks = tasks.where((task) => task.isAnswered).length;

    var correct = 0;
    var total = 0;

    for (final task in tasks) {
      final result = task.result;

      if (result == null) {
        continue;
      }

      if (result.accuracy != null) {
        correct += result.accuracy!.correct;
        total += result.accuracy!.total;
      } else {
        total += 1;

        if (result.isCorrect) {
          correct += 1;
        }
      }
    }

    return TopicAttemptResult(
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      accuracy: AccuracyResult(correct: correct, total: total),
      duration: duration,
    );
  }
}
