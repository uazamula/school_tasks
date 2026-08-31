import 'package:school_tasks/features/learning/domain/attempts/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
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

    final correctTasks = tasks
        .where((task) => task.result?.isCorrect == true)
        .length;

    return TopicAttemptResult(
      totalTasks: tasks.length,
      completedTasks: completedTasks,
      correctTasks: correctTasks,
      duration: duration,
    );
  }
}
