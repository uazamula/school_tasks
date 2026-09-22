import 'package:flutter/material.dart';

import 'package:school_tasks/features/learning/domain/grid_position.dart';
import 'package:school_tasks/features/learning/domain/rational.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/fraction_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/input_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/learning_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/position_selection_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/selection_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/fraction_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/input_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/position_selection_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.promptScrollable,
    required this.onTaskAnswered,
    required this.onProgressStep,
    required this.onCorrectPair,
    required this.onIncorrectPair,
    required this.feedbackEnabled,
    this.interactionScrollable = false,
  });

  final LearningTask<dynamic, dynamic> task;
  final TaskResult<dynamic, dynamic>? result;
  final bool promptScrollable;
  final bool interactionScrollable;
  final ValueChanged<TaskResult<dynamic, dynamic>> onTaskAnswered;
  final VoidCallback onProgressStep;
  final VoidCallback onCorrectPair;
  final VoidCallback onIncorrectPair;
  final bool feedbackEnabled;

  Widget buildPrompt() {
    return TaskPromptWidget(prompt: task.prompt, scrollable: promptScrollable);
  }

  Widget buildInteraction() {
    if (task is SelectionTask) {
      return TaskInteractionScalingBoundary(
        child: SelectionTaskWidget<dynamic, dynamic, dynamic>(
          task: task as SelectionTask<dynamic, dynamic, dynamic>,
          result: result,
          interactionScrollable: interactionScrollable,
          onTaskAnswered: onTaskAnswered,
        ),
      );
    }

    if (task is FractionTask) {
      return TaskInteractionScalingBoundary(
        child: FractionTaskWidget(
          task: task as FractionTask,
          result: result as TaskResult<Set<int>, int>?,
          interactionScrollable: interactionScrollable,
          onTaskAnswered: onTaskAnswered,
        ),
      );
    }

    if (task is PositionSelectionTask) {
      return TaskInteractionScalingBoundary(
        child: PositionSelectionTaskWidget(
          task: task as PositionSelectionTask,
          result: result as TaskResult<List<GridPosition>, List<GridPosition>>?,
          interactionScrollable: interactionScrollable,
          onTaskAnswered: onTaskAnswered,
        ),
      );
    }

    if (task is MatchingTask) {
      return MatchingTaskWidget(
        task: task as MatchingTask,
        result: result as TaskResult<MatchingAnswer, List<MatchingPair>>?,
        onTaskAnswered: onTaskAnswered,
        onProgressStep: onProgressStep,
        onCorrectPair: onCorrectPair,
        onIncorrectPair: onIncorrectPair,
        feedbackEnabled: feedbackEnabled,
      );
    }

    if (task is InputTask) {
      return TaskInteractionScalingBoundary(
        child: InputTaskWidget(
          task: task as InputTask,
          result: result as TaskResult<Rational, Rational>?,
          interactionScrollable: interactionScrollable,
          onTaskAnswered: onTaskAnswered,
        ),
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
