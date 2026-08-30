import 'task_prompt.dart';

abstract class TaskData {
  const TaskData({required this.prompt});

  final TaskPrompt prompt;
}
