import 'dart:math';

import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/matching_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_prompt_widget.dart';

class MatchingTaskWidget extends StatefulWidget {
  const MatchingTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
  });

  final MatchingTask task;
  final TaskResult<MatchingAnswer, List<MatchingPair>>? result;

  final ValueChanged<TaskResult<MatchingAnswer, List<MatchingPair>>>
  onTaskAnswered;

  @override
  State<MatchingTaskWidget> createState() => _MatchingTaskWidgetState();
}

class _MatchingTaskWidgetState extends State<MatchingTaskWidget> {
  int? _selectedLeftIndex;
  int? _selectedRightIndex;

  /// Індекси пар, які вже правильно з'єднані.
  final Set<int> _completedPairIndices = {};

  /// Індекси пар, для яких уже була перша спроба.
  final Set<int> _attemptedPairIndices = {};

  /// Індекси пар, які були правильно з'єднані з першої спроби.
  final Set<int> _firstAttemptCorrectPairIndices = {};

  final Random _random = Random();

  late List<int> _rightOrder;

  @override
  void initState() {
    super.initState();
    _createRightOrder();
  }

  void _createRightOrder() {
    _rightOrder = List.generate(widget.task.pairs.length, (index) => index)
      ..shuffle(_random);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TaskPromptWidget(prompt: widget.task.prompt),

        const SizedBox(height: AppSpacing.xl),

        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLeftColumn(),
            const SizedBox(width: AppSpacing.xl),
            _buildRightColumn(),
          ],
        ),
      ],
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < widget.task.pairs.length; index++)
          if (!_completedPairIndices.contains(index))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildSelectableContent(
                content: widget.task.pairs[index].left,
                isSelected: _selectedLeftIndex == index,
                onTap: () => _selectLeft(index),
              ),
            ),
      ],
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

  Widget _buildRightColumn() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final index in _rightOrder)
          if (!_completedPairIndices.contains(index))
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildSelectableContent(
                content: widget.task.pairs[index].right,
                isSelected: _selectedRightIndex == index,
                onTap: () => _selectRight(index),
              ),
            ),
      ],
    );
  }

  Widget _buildSelectableContent({
    required TaskContent content,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minWidth: 100, minHeight: 56),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: _buildContent(content),
      ),
    );
  }

  Widget _buildContent(TaskContent content) {
    if (content is TextContent) {
      return Text(content.text, textAlign: TextAlign.center);
    }

    if (content is EmojiContent) {
      return Text(content.emoji, style: const TextStyle(fontSize: 40));
    }

    if (content is ImageContent) {
      return SizedBox(
        width: 80,
        height: 80,
        child: Image.asset(content.imagePath, fit: BoxFit.contain),
      );
    }

    return const SizedBox.shrink();
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
