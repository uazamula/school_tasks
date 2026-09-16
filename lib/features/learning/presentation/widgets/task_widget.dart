import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/fraction_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/numeric_input_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/position_selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/fraction_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/numeric_input_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/position_selection_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
    required this.onProgressStep,
    required this.onCorrectPair,
  });

  final LearningTask<dynamic, dynamic> task;
  final TaskResult<dynamic, dynamic>? result;
  final ValueChanged<TaskResult<dynamic, dynamic>> onTaskAnswered;
  final VoidCallback onProgressStep;
  final VoidCallback onCorrectPair;
  Widget buildPrompt() {
    return TaskPromptWidget(prompt: task.prompt);
  }

  Widget buildInteraction() {
    if (task is SelectionTask) {
      return SelectionTaskWidget<dynamic, dynamic, dynamic>(
        task: task as SelectionTask<dynamic, dynamic, dynamic>,
        result: result,
        onTaskAnswered: onTaskAnswered,
      );
    }

    if (task is FractionTask) {
      return FractionTaskWidget(
        task: task as FractionTask,
        result: result as TaskResult<Set<int>, int>?,
        onTaskAnswered: onTaskAnswered,
      );
    }

    if (task is PositionSelectionTask) {
      return PositionSelectionTaskWidget(
        task: task as PositionSelectionTask,
        result: result as TaskResult<List<GridPosition>, List<GridPosition>>?,
        onTaskAnswered: onTaskAnswered,
      );
    }

    if (task is MatchingTask) {
      return MatchingTaskWidget(
        task: task as MatchingTask,
        result: result as TaskResult<MatchingAnswer, List<MatchingPair>>?,
        onTaskAnswered: onTaskAnswered,
        onProgressStep: onProgressStep,
        onCorrectPair: onCorrectPair,
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildPrompt(), buildInteraction()],
    );
  }
}
