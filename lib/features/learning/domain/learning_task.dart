import 'package:school_tasks/features/learning/domain/task_result.dart';

abstract class LearningTask<TAnswer> {
  const LearningTask({required this.condition});

  final String condition;

  TaskResult<TAnswer> checkAnswer(TAnswer answer);
}
