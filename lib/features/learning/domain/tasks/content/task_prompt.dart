import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/target_content.dart';

class TaskPrompt {
  const TaskPrompt({
    required this.content,
    this.target,
  });

  final List<TaskContent> content;
  final TargetContent? target;
}