import 'package:school_tasks/features/learning/domain/tasks/content/task_prompt.dart';

abstract class TaskData {
  const TaskData({required this.prompt});

  final TaskPrompt prompt;
}
