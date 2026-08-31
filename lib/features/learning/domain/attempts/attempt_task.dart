import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';

class AttemptTask<TAnswer, TSolution> {
  AttemptTask({required this.task});

  final LearningTask<TAnswer, TSolution> task;
  TaskResult<TAnswer, TSolution>? result;

  bool get isAnswered => result != null;
}
