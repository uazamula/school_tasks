import 'dart:async';
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
    required this.onIncorrectPair,
    required this.onIncorrectPairAttempt,
    required this.onAccuracyChanged,
  });

  final MatchingTask task;
  final TaskResult<MatchingAnswer, List<MatchingPair>>? result;
  final ValueChanged<TaskResult<MatchingAnswer, List<MatchingPair>>>
  onTaskAnswered;
  final VoidCallback onProgressStep;
  final VoidCallback onCorrectPair;
  final bool feedbackEnabled;
  final VoidCallback onIncorrectPair;
  final bool Function() onIncorrectPairAttempt;
  final ValueChanged<AccuracyResult> onAccuracyChanged;

  @override
  State<MatchingTaskWidget> createState() => _MatchingTaskWidgetState();
}

class _MatchingTaskWidgetState extends State<MatchingTaskWidget> {
  int? _selectedLeftIndex;
  int? _selectedRightIndex;

  /// Пари розв'язку, що вже «спожиті». Пошук іде за значенням,
  /// тому дублікати взаємозамінні.
  final Set<int> _consumedPairIndices = {};

  /// Приховані елементи кожної колонки: рівно ті, на які натиснув
  /// користувач (а не ті, що збіглися за значенням).
  final Set<int> _hiddenLeftIndices = {};
  final Set<int> _hiddenRightIndices = {};

  /// Ліві елементи, з якими вже була спроба (правильна чи ні).
  final Set<int> _attemptedLeftIndices = {};

  /// Ліві елементи, зіставлені правильно з першої спроби.
  final Set<int> _firstAttemptCorrectLeftIndices = {};

  final Random _random = Random();

  late List<int> _rightOrder;
  late List<int> _leftOrder;

  Future<void>? _pendingAudioPlayback;
  bool _isFinishing = false;

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
      hiddenIndices: _hiddenLeftIndices,
      selectedIndex: _selectedLeftIndex,
      isLeft: true,
      onItemTap: _selectLeft,
      buttonConfig: widget.task.buttonConfig,
      onAudioPlaybackStarted: _rememberAudioPlayback,
    );
  }

  Widget _buildRightColumn() {
    return MatchingColumn(
      pairs: widget.task.pairs,
      order: _rightOrder,
      hiddenIndices: _hiddenRightIndices,
      selectedIndex: _selectedRightIndex,
      isLeft: false,
      onItemTap: _selectRight,
      buttonConfig: widget.task.buttonConfig,
      onAudioPlaybackStarted: _rememberAudioPlayback,
    );
  }

  @override
  void didUpdateWidget(covariant MatchingTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _selectedLeftIndex = null;
      _selectedRightIndex = null;

      _consumedPairIndices.clear();
      _hiddenLeftIndices.clear();
      _hiddenRightIndices.clear();
      _attemptedLeftIndices.clear();
      _firstAttemptCorrectLeftIndices.clear();

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
      final shouldFinish = widget.onIncorrectPairAttempt();

      if (widget.feedbackEnabled) {
        widget.onIncorrectPair();
      }

      if (shouldFinish) {
        return;
      }

      _attemptedLeftIndices.add(leftIndex);
      _clearSelection();
      setState(() {});
      return;
    }

    _registerCorrectAttempt(leftIndex);

    // Пара розв'язку споживається за значенням, а ховаються саме ті
    // елементи, на які натиснули (важливо при дублікатах).
    _consumedPairIndices.add(pairIndex);
    _hiddenLeftIndices.add(leftIndex);
    _hiddenRightIndices.add(rightIndex);

    widget.onAccuracyChanged(
      AccuracyResult(
        correct: _firstAttemptCorrectLeftIndices.length,
        total: widget.task.pairs.length,
      ),
    );

    // Одна правильно складена пара = один крок прогресу.
    // Правильність першої спроби на прогрес не впливає.
    if (widget.feedbackEnabled) {
      widget.onCorrectPair();
    }

    widget.onProgressStep();

    _clearSelection();
    setState(() {});

    if (_consumedPairIndices.length == widget.task.pairs.length) {
      unawaited(_finishTask());
    }
  }

  int? _findCorrectPair(MatchingAnswer answer) {
    for (var index = 0; index < widget.task.pairs.length; index++) {
      if (_consumedPairIndices.contains(index)) {
        continue;
      }

      final pair = widget.task.pairs[index];

      if (pair.left == answer.left && pair.right == answer.right) {
        return index;
      }
    }

    return null;
  }

  /// Правильна спроба з першого разу: лівий елемент раніше не фігурував
  /// у спробах (ні в правильних, ні в неправильних).
  void _registerCorrectAttempt(int leftIndex) {
    final isFirstAttempt = !_attemptedLeftIndices.contains(leftIndex);

    _attemptedLeftIndices.add(leftIndex);

    if (isFirstAttempt) {
      _firstAttemptCorrectLeftIndices.add(leftIndex);
    }
  }

  void _clearSelection() {
    _selectedLeftIndex = null;
    _selectedRightIndex = null;
  }

  Future<void> _finishTask() async {
    if (_isFinishing) {
      return;
    }
    _isFinishing = true;

    final accuracy = AccuracyResult(
      correct: _firstAttemptCorrectLeftIndices.length,
      total: widget.task.pairs.length,
    );

    final result = TaskResult<MatchingAnswer, List<MatchingPair>>(
      state: TaskAnswerState.correct,
      accuracy: accuracy,
    );

    final playback = _pendingAudioPlayback;
    _pendingAudioPlayback = null;

    if (playback != null) {
      await playback;
    }

    if (!mounted) {
      return;
    }

    widget.onTaskAnswered(result);
  }

  void _rememberAudioPlayback(Future<void>? playback) {
    if (playback != null) {
      _pendingAudioPlayback = playback;
    }
  }
}
