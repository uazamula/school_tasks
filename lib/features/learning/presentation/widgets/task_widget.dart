import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/numeric_input_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection_task_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final LearningTask<dynamic, dynamic> task;
  final TaskResult<dynamic, dynamic>? result;
  final ValueChanged<TaskResult<dynamic, dynamic>> onTaskAnswered;

  @override
  Widget build(BuildContext context) {
    if (task is SelectionTask) {
      return SelectionTaskWidget<dynamic, dynamic, dynamic>(
        task: task as SelectionTask<dynamic, dynamic, dynamic>,
        result: result as TaskResult<dynamic, dynamic>?,
        onTaskAnswered: onTaskAnswered,
      );
    }

    if (task is NumericInputTask) {
      return NumericInputTaskWidget(
        task: task as NumericInputTask,
        result: result as TaskResult<int, int>?,
        onTaskAnswered: onTaskAnswered,
      );
    }

    return const SizedBox.shrink();
  }
}
