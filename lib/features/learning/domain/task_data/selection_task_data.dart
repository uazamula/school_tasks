import 'package:school_tasks/features/learning/domain/task_data/task_data.dart';

class SelectionTaskData<TOption, TSolution> extends TaskData {
  const SelectionTaskData({
    required super.prompt,
    required this.options,
    required this.solution,
  });

  final List<TOption> options;
  final TSolution solution;
}
