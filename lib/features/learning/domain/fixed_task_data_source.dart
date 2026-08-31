import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_source.dart';

class FixedTaskDataSource extends TaskDataSource {
  const FixedTaskDataSource(this.data);

  final List<TaskData> data;

  @override
  List<TaskData> getData() => data;
}
