import 'package:school_tasks/features/learning/domain/attempts/attempt_task.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';

class TopicAttempt {
  TopicAttempt({required List<AttemptTask<dynamic, dynamic>> tasks})
    : tasks = List.unmodifiable(tasks);

  final List<AttemptTask<dynamic, dynamic>> tasks;

  int currentTaskIndex = 0;

  AttemptTask<dynamic, dynamic> get currentTask => tasks[currentTaskIndex];

  bool get isFinished => tasks.every((task) => task.isAnswered);

  int get completedTasks => tasks.where((task) => task.isAnswered).length;

  final Map<int, AccuracyResult> _matchingAccuracy = {};

  int get incorrectAnswers {
    var incorrect = 0;

    for (final task in tasks) {
      final result = task.result;

      if (result == null) {
        continue;
      }

      if (result.accuracy != null) {
        incorrect += result.accuracy!.total - result.accuracy!.correct;
      } else if (!result.isCorrect) {
        incorrect++;
      }
    }

    return incorrect;
  }

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

    for (var index = 0; index < tasks.length; index++) {
      final taskAttempt = tasks[index];
      final result = taskAttempt.result;

      if (result != null) {
        if (result.accuracy != null) {
          correct += result.accuracy!.correct;
          total += result.accuracy!.total;
        } else {
          total += 1;

          if (result.isCorrect) {
            correct += 1;
          }
        }
      } else {
        final task = taskAttempt.task;
        final matchingAccuracy = _matchingAccuracy[index];

        if (matchingAccuracy != null) {
          correct += matchingAccuracy.correct;
          total += matchingAccuracy.total;
        } else if (task is MatchingTask) {
          total += task.pairs.length;
        } else {
          total += 1;
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

  void updateMatchingAccuracy(int taskIndex, AccuracyResult accuracy) {
    _matchingAccuracy[taskIndex] = accuracy;
  }
}
