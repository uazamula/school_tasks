import 'task_data.dart';
import 'task_data_source.dart';

class FixedTaskDataSource extends TaskDataSource {
  const FixedTaskDataSource(this.data);

  final List<TaskData> data;

  @override
  List<TaskData> getData() => data;
}
