import 'package:flutter/material.dart';
import 'package:school_tasks/features/learning/domain/multi_choice_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/multi_choice_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/numeric_input_task_widget.dart';
import '../../domain/choice_task.dart';
import '../../domain/learning_task.dart';
import '../../domain/numeric_input_task.dart';
import '../../domain/task_result.dart';
import 'choice_task_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final LearningTask<dynamic> task;
  final TaskResult<dynamic>? result;
  final ValueChanged<TaskResult<dynamic>> onTaskAnswered;

  @override
  Widget build(BuildContext context) {
    if (task is ChoiceTask) {
      return ChoiceTaskWidget(
        task: task as ChoiceTask,
        result: result as TaskResult<int>?,
        onTaskAnswered: (result) {
          onTaskAnswered(result);
        },
      );
    }

    if (task is NumericInputTask) {
      return NumericInputTaskWidget(
        task: task as NumericInputTask,
        result: result as TaskResult<int>?,
        onTaskAnswered: (result) {
          onTaskAnswered(result);
        },
      );
    }

    if (task is MultiChoiceTask) {
      return MultiChoiceTaskWidget(
        task: task as MultiChoiceTask,
        result: result as TaskResult<List<String>>?,
        onTaskAnswered: (result) {
          onTaskAnswered(result);
        },
      );
    }

    return const SizedBox.shrink();
  }
}
