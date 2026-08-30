import 'learning_task.dart';
import 'task_result.dart';

class AttemptTask<TAnswer, TSolution> {
  AttemptTask({required this.task});

  final LearningTask<TAnswer, TSolution> task;
  TaskResult<TAnswer, TSolution>? result;

  bool get isAnswered => result != null;
}
