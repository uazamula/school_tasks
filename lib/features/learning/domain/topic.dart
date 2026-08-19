import 'package:school_tasks/features/learning/domain/learning_type_task.dart';

class Topic {
  const Topic({required this.id, required this.taskTypeCounts});

  final String id;
  final Map<LearningTaskType, int> taskTypeCounts;

  int get totalTasks {
    return taskTypeCounts.values.fold(0, (sum, count) => sum + count);
  }
}
