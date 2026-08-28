import 'task_data.dart';

abstract class TaskDataSource {
  const TaskDataSource();

  List<TaskData> getData();
}
