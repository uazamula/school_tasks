import 'package:school_tasks/features/learning/domain/task_data.dart';

abstract class TaskDataGenerator {
  const TaskDataGenerator();

  List<TaskData> generate();
}
