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
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/fraction_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/input_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/position_selection_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly_task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_callbacks.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.promptScrollable,
    required this.callbacks,
    required this.feedbackEnabled,
    this.interactionScrollable = false,
    this.targetProgress = 0,
  });

  final LearningTask<dynamic, dynamic> task;
  final TaskResult<dynamic, dynamic>? result;
  final bool promptScrollable;
  final bool interactionScrollable;
  final TaskCallbacks callbacks;
  final bool feedbackEnabled;
  final int targetProgress;

  Widget buildPrompt() {
    return TaskPromptWidget(
      prompt: task.prompt,
      scrollable: promptScrollable,
      targetProgress: targetProgress,
    );
  }

  Widget buildInteraction() {
    // Matching сам керує розкладкою, тому без обгортки.
    if (task is MatchingTask) {
      return _buildMatching();
    }

    final interaction = _buildScalableInteraction();

    if (interaction == null) {
      return const SizedBox.shrink();
    }

    return TaskInteractionScalingBoundary(child: interaction);
  }

  /// Віджет взаємодії для типів, що вкладаються в TaskInteractionScalingBoundary.
  Widget? _buildScalableInteraction() {
    if (task is SelectionTask) {
      return SelectionTaskWidget<dynamic, dynamic, dynamic>(
        task: task as SelectionTask<dynamic, dynamic, dynamic>,
        result: result,
        interactionScrollable: interactionScrollable,
        onTaskAnswered: callbacks.onTaskAnswered,
        feedbackEnabled: feedbackEnabled,
      );
    }

    if (task is FractionTask) {
      return FractionTaskWidget(
        task: task as FractionTask,
        result: result as TaskResult<Set<int>, int>?,
        interactionScrollable: interactionScrollable,
        onTaskAnswered: callbacks.onTaskAnswered,
        feedbackEnabled: feedbackEnabled,
      );
    }

    if (task is PositionSelectionTask) {
      return PositionSelectionTaskWidget(
        task: task as PositionSelectionTask,
        result: result as TaskResult<List<GridPosition>, List<GridPosition>>?,
        interactionScrollable: interactionScrollable,
        onTaskAnswered: callbacks.onTaskAnswered,
        feedbackEnabled: feedbackEnabled,
      );
    }

    if (task is InputTask) {
      return InputTaskWidget(
        task: task as InputTask,
        result: result as TaskResult<Rational, Rational>?,
        interactionScrollable: interactionScrollable,
        onTaskAnswered: callbacks.onTaskAnswered,
        feedbackEnabled: feedbackEnabled,
      );
    }

    if (task is SlotAssemblyTask) {
      return _buildSlotAssembly();
    }

    return null;
  }

  Widget _buildMatching() {
    return MatchingTaskWidget(
      key: ObjectKey(task),
      task: task as MatchingTask,
      result: result as TaskResult<MatchingAnswer, List<MatchingPair>>?,
      onTaskAnswered: callbacks.onTaskAnswered,
      onProgressStep: callbacks.onProgressStep,
      onCorrectPair: callbacks.onCorrectPair,
      onIncorrectPair: callbacks.onIncorrectPair,
      feedbackEnabled: feedbackEnabled,
      onIncorrectPairAttempt: callbacks.onIncorrectPairAttempt,
      onAccuracyChanged: callbacks.onMatchingAccuracyChanged,
    );
  }

  Widget _buildSlotAssembly() {
    return SlotAssemblyTaskWidget<dynamic>(
      key: ObjectKey(task),
      task: task as SlotAssemblyTask<dynamic>,
      result: result as TaskResult<List<dynamic>, List<dynamic>>?,
      interactionScrollable: interactionScrollable,
      onTaskAnswered: callbacks.onTaskAnswered,
      onAccuracyChanged: callbacks.onMatchingAccuracyChanged,
      // Звук фідбеку після кожної спроби доставки елемента в слот,
      // за тим самим принципом, що й у Matching.
      onCorrectSlotFilled: (progress) {
        if (feedbackEnabled) callbacks.onCorrectPair();
        callbacks.onCorrectSlotFilled?.call(progress);
      },
      onIncorrectAttempt: () {
        final shouldFinish = callbacks.onIncorrectPairAttempt();
        if (feedbackEnabled) callbacks.onIncorrectPair();
        return shouldFinish;
      },
      onElementReachedEdge: callbacks.onElementReachedEdge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [buildPrompt(), buildInteraction()],
    );
  }
}
