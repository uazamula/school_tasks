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
    if (task is SelectionTask<int, int, int>) {
      return SelectionTaskWidget<int, int, int>(
        task: task as SelectionTask<int, int, int>,
        result: result as TaskResult<int, int>?,
        onTaskAnswered: onTaskAnswered,
      );
    }

    if (task is SelectionTask<String, List<String>, List<String>>) {
      return SelectionTaskWidget<String, List<String>, List<String>>(
        task: task as SelectionTask<String, List<String>, List<String>>,
        result: result as TaskResult<List<String>, List<String>>?,
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
