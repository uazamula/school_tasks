import 'package:school_tasks/features/learning/domain/learning_task_type.dart';
import 'package:school_tasks/features/learning/domain/task_data.dart';

class Topic {
  const Topic({
    required this.id,
    required this.taskTypeCounts,
    required this.taskData,
    required this.help,
  });

  final String id;
  final Map<LearningTaskType, int> taskTypeCounts;
  final List<TaskData> taskData;
  final String help;

  int get totalTasks {
    return taskTypeCounts.values.fold(0, (sum, count) => sum + count);
  }
}
