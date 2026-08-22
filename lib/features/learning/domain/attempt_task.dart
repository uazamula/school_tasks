import 'learning_task.dart';
import 'task_result.dart';

class AttemptTask {
  AttemptTask({required this.task});

  final LearningTask<int> task;
  TaskResult<int>? result;

  bool get isAnswered => result != null;
}
