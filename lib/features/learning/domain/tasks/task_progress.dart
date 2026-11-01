import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';

/// Завдання, що саме звітує про прогрес і озвучує кожну спробу
/// (кожну пару, кожен слот), а не лише кінцевий результат.
bool reportsOwnProgress(LearningTask<dynamic, dynamic> task) {
  return task is MatchingTask || task is SlotAssemblyTask;
}

/// Кількість кроків прогресу, які дає завдання.
int progressStepsOf(LearningTask<dynamic, dynamic> task) {
  if (task is MatchingTask) return task.pairs.length;
  if (task is SlotAssemblyTask) return task.correctAnswers.length;
  return 1;
}

/// Загальна кількість кроків прогресу для набору завдань.
int totalProgressSteps(Iterable<LearningTask<dynamic, dynamic>> tasks) {
  var total = 0;

  for (final task in tasks) {
    total += progressStepsOf(task);
  }

  return total;
}
