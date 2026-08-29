import 'package:school_tasks/features/learning/domain/task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_source.dart';

import 'task_data_generator.dart';

class GeneratedTaskDataSource extends TaskDataSource {
  const GeneratedTaskDataSource(this.generator);

  final TaskDataGenerator generator;

  @override
  List<TaskData> getData() {
    return generator.generate();
  }
}
