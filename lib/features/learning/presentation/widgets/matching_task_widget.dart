import 'dart:math';

import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/matching/matching_column.dart';

class MatchingTaskWidget extends StatefulWidget {
  const MatchingTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
    required this.onProgressStep,
    required this.onCorrectPair,
    required this.feedbackEnabled,
  });

  final MatchingTask task;
  final TaskResult<MatchingAnswer, List<MatchingPair>>? result;
  final ValueChanged<TaskResult<MatchingAnswer, List<MatchingPair>>>
  onTaskAnswered;
  final VoidCallback onProgressStep;
  final VoidCallback onCorrectPair;
  final bool feedbackEnabled;

  @override
  State<MatchingTaskWidget> createState() => _MatchingTaskWidgetState();
}

class _MatchingTaskWidgetState extends State<MatchingTaskWidget> {
  int? _selectedLeftIndex;
  int? _selectedRightIndex;

  final Set<int> _completedPairIndices = {};
  final Set<int> _attemptedPairIndices = {};
  final Set<int> _firstAttemptCorrectPairIndices = {};

  final Random _random = Random();

  late List<int> _rightOrder;
  late List<int> _leftOrder;

  @override
  void initState() {
    super.initState();
    _createRightOrder();
  }

  void _createRightOrder() {
    _leftOrder = List.generate(widget.task.pairs.length, (index) => index);

    _rightOrder = List.generate(widget.task.pairs.length, (index) => index)
      ..shuffle(_random);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final double columnWidth = max(0, (availableWidth - AppSpacing.lg) / 2);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: availableWidth,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(width: columnWidth, child: _buildLeftColumn()),

                  const SizedBox(width: AppSpacing.lg),

                  SizedBox(width: columnWidth, child: _buildRightColumn()),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLeftColumn() {
    return MatchingColumn(
      pairs: widget.task.pairs,
      order: _leftOrder,
      completedPairIndices: _completedPairIndices,
      selectedIndex: _selectedLeftIndex,
      isLeft: true,
      onItemTap: _selectLeft,
    );
  }

  Widget _buildRightColumn() {
    return MatchingColumn(
      pairs: widget.task.pairs,
      order: _rightOrder,
      completedPairIndices: _completedPairIndices,
      selectedIndex: _selectedRightIndex,
      isLeft: false,
      onItemTap: _selectRight,
    );
  }

  @override
  void didUpdateWidget(covariant MatchingTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _selectedLeftIndex = null;
      _selectedRightIndex = null;

      _completedPairIndices.clear();
      _attemptedPairIndices.clear();
      _firstAttemptCorrectPairIndices.clear();

      _createRightOrder();
    }
  }

  void _selectLeft(int index) {
    setState(() {
      if (_selectedLeftIndex == index) {
        _selectedLeftIndex = null;
      } else {
        _selectedLeftIndex = index;
      }
    });

    _tryMatch();
  }

  void _selectRight(int index) {
    setState(() {
      if (_selectedRightIndex == index) {
        _selectedRightIndex = null;
      } else {
        _selectedRightIndex = index;
      }
    });

    _tryMatch();
  }

  void _tryMatch() {
    final leftIndex = _selectedLeftIndex;
    final rightIndex = _selectedRightIndex;

    if (leftIndex == null || rightIndex == null) {
      return;
    }

    final left = widget.task.pairs[leftIndex].left;
    final right = widget.task.pairs[rightIndex].right;

    final answer = MatchingAnswer(left: left, right: right);

    final pairIndex = _findCorrectPair(answer);

    if (pairIndex == null) {
      _registerIncorrectAttempt(leftIndex);
      _clearSelection();
      setState(() {});
      return;
    }

    _registerCorrectAttempt(pairIndex);
    _completedPairIndices.add(pairIndex);

    // Одна правильно складена пара = один крок прогресу.
    // Правильність першої спроби на прогрес не впливає.
    if (widget.feedbackEnabled) {
      widget.onCorrectPair();
    }

    widget.onProgressStep();

    _clearSelection();

    if (_completedPairIndices.length == widget.task.pairs.length) {
      _finishTask();
      return;
    }

    setState(() {});
  }

  int? _findCorrectPair(MatchingAnswer answer) {
    for (var index = 0; index < widget.task.pairs.length; index++) {
      if (_completedPairIndices.contains(index)) {
        continue;
      }

      final pair = widget.task.pairs[index];

      if (pair.left == answer.left && pair.right == answer.right) {
        return index;
      }
    }

    return null;
  }

  void _registerIncorrectAttempt(int leftIndex) {
    _attemptedPairIndices.add(leftIndex);
  }

  void _registerCorrectAttempt(int pairIndex) {
    final isFirstAttempt = !_attemptedPairIndices.contains(pairIndex);

    _attemptedPairIndices.add(pairIndex);

    if (isFirstAttempt) {
      _firstAttemptCorrectPairIndices.add(pairIndex);
    }
  }

  void _clearSelection() {
    _selectedLeftIndex = null;
    _selectedRightIndex = null;
  }

  void _finishTask() {
    final accuracy = AccuracyResult(
      correct: _firstAttemptCorrectPairIndices.length,
      total: widget.task.pairs.length,
    );

    final result = TaskResult<MatchingAnswer, List<MatchingPair>>(
      state: TaskAnswerState.correct,
      accuracy: accuracy,
    );

    widget.onTaskAnswered(result);
  }
}
