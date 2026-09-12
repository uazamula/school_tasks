import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_source.dart';

class CompositeTaskDataSource extends TaskDataSource {
  const CompositeTaskDataSource(this.sources);

  final List<TaskDataSource> sources;

  @override
  List<TaskData> getData() {
    return [for (final source in sources) ...source.getData()];
  }
}
