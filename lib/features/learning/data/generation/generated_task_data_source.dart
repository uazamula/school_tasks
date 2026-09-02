import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';
import 'package:school_tasks/features/learning/domain/task_data_source.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task_type.dart';

import 'task_data_generator.dart';

class GeneratedTaskDataSource extends TaskDataSource {
  GeneratedTaskDataSource(this.generators);

  final Map<LearningTaskType, TaskDataGenerator> generators;

  @override
  List<TaskData> getData() {
    return [for (final generator in generators.values) ...generator.generate()];
  }
}

// class GeneratedTaskDataSource extends TaskDataSource {
//   GeneratedTaskDataSource(this.generator);
//
//   final TaskDataGenerator generator;
//
//   @override
//   List<TaskData> getData() {
//     return generator.generate();
//   }
// }
