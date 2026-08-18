import 'package:flutter/material.dart';
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
    required this.onAnswerSelected,
  });

  final LearningTask task;
  final TaskResult<int>? result;
  final ValueChanged<int> onAnswerSelected;

  @override
  Widget build(BuildContext context) {
    if (task is ChoiceTask) {
      return ChoiceTaskWidget(
        task: task as ChoiceTask,
        result: result,
        onAnswerSelected: onAnswerSelected,
      );
    }

    if (task is NumericInputTask) {
      return const Text('NumericInputTask');
    }

    return const SizedBox.shrink();
  }
}
