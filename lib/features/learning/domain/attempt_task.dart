import 'learning_task.dart';
import 'task_result.dart';

class AttemptTask<TAnswer> {
  AttemptTask({required this.task});

  final LearningTask<TAnswer> task;
  TaskResult<TAnswer>? result;

  bool get isAnswered => result != null;
}
