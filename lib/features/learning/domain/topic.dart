import 'package:school_tasks/features/learning/domain/learning_type_task.dart';

class Topic {
  const Topic({
    required this.id,
    required this.totalTasks,
    required this.taskTypes,
  });

  final String id;
  final int totalTasks;
  final List<LearningTaskType> taskTypes;
}
