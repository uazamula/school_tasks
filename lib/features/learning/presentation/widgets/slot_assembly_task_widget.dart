import 'package:flutter/material.dart';

import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/selection/choice_answer_button.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';

class SlotAssemblyTaskWidget<TOption> extends StatefulWidget {
  const SlotAssemblyTaskWidget({
    super.key,
    required this.task,
    required this.result,
    required this.onTaskAnswered,
    required this.onAccuracyChanged,
    this.interactionScrollable = false,
    this.onCorrectSlotFilled,
    required this.onIncorrectAttempt,
  });

  final SlotAssemblyTask<TOption> task;
  final TaskResult<List<TOption>, List<TOption>>? result;
  final ValueChanged<TaskResult<List<TOption>, List<TOption>>> onTaskAnswered;
  final ValueChanged<AccuracyResult> onAccuracyChanged;
  final bool interactionScrollable;
  final ValueChanged<int>? onCorrectSlotFilled;
  final bool Function() onIncorrectAttempt;

  @override
  State<SlotAssemblyTaskWidget<TOption>> createState() =>
      _SlotAssemblyTaskWidgetState<TOption>();
}

class _SlotAssemblyTaskWidgetState<TOption>
    extends State<SlotAssemblyTaskWidget<TOption>> {
  late List<int?> _slotOptionIndices;

  final Set<int> _usedOptionIndices = {};
  final Set<int> _attemptedSlots = {};
  final Set<int> _firstAttemptCorrectSlots = {};
  int _correctSlotsCount = 0;
  AudioLinkedContent? _activeAudioOption;

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  bool get _requiresSequentialSelection =>
      (widget.task.interaction as SlotAssemblyInteraction)
          .requiresSequentialSelection;

  @override
  void initState() {
    super.initState();
    _resetSlots();
  }

  @override
  void didUpdateWidget(covariant SlotAssemblyTaskWidget<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _resetSlots();
      _activeAudioOption = null;
    }
  }

  void _resetSlots() {
    _slotOptionIndices = List<int?>.filled(
      widget.task.correctAnswers.length,
      null,
    );
    _activeAudioOption = null;
    _correctSlotsCount = 0;
    _usedOptionIndices.clear();
    _attemptedSlots.clear();
    _firstAttemptCorrectSlots.clear();
  }

  int? _nextEmptySlot() {
    for (var i = 0; i < _slotOptionIndices.length; i++) {
      if (_slotOptionIndices[i] == null) return i;
    }

    return null;
  }

  int? _findMatchingEmptySlot(TOption option) {
    for (var i = 0; i < widget.task.correctAnswers.length; i++) {
      if (_slotOptionIndices[i] == null &&
          widget.task.correctAnswers[i] == option) {
        return i;
      }
    }

    return null;
  }

  void _onOptionSelected(int optionIndex) {
    if (_isAnswered || _usedOptionIndices.contains(optionIndex)) return;

    final option = widget.task.options[optionIndex];

    // Аудіо запускається незалежно від правильності відповіді.
    setState(() {
      _activeAudioOption = option is AudioLinkedContent ? option : null;
    });

    final nextEmptySlot = _nextEmptySlot();
    if (nextEmptySlot == null) return;

    final targetSlot = _requiresSequentialSelection
        ? (widget.task.correctAnswers[nextEmptySlot] == option
              ? nextEmptySlot
              : null)
        : _findMatchingEmptySlot(option);

    if (targetSlot == null) {
      setState(() {
        _attemptedSlots.add(nextEmptySlot);
      });
      widget.onIncorrectAttempt();
      return;
    }

    setState(() {
      _slotOptionIndices[targetSlot] = optionIndex;
      _usedOptionIndices.add(optionIndex);
      _correctSlotsCount++;

      if (!_attemptedSlots.contains(targetSlot)) {
        _firstAttemptCorrectSlots.add(targetSlot);
      }
    });

    widget.onCorrectSlotFilled?.call(_correctSlotsCount);
    _notifyAccuracy();

    if (_slotOptionIndices.every((index) => index != null)) {
      _finishTask();
    }
  }

  void _notifyAccuracy() {
    widget.onAccuracyChanged(
      AccuracyResult(
        correct: _firstAttemptCorrectSlots.length,
        total: widget.task.correctAnswers.length,
      ),
    );
  }

  void _finishTask() {
    if (_isAnswered) return;

    final answer = <TOption>[
      for (final index in _slotOptionIndices) widget.task.options[index!],
    ];

    final checkedResult = widget.task.checkAnswer(answer);

    widget.onTaskAnswered(
      TaskResult<List<TOption>, List<TOption>>(
        state: checkedResult.state,
        selectedAnswer: checkedResult.selectedAnswer,
        solution: checkedResult.solution,
        accuracy: AccuracyResult(
          correct: _firstAttemptCorrectSlots.length,
          total: widget.task.correctAnswers.length,
        ),
      ),
    );
  }

  Widget _buildSlots() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        for (var i = 0; i < _slotOptionIndices.length; i++)
          Container(
            constraints: const BoxConstraints(minWidth: 64, minHeight: 56),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.md,
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _slotOptionIndices[i] == null
                  ? '___'
                  : _displayText(widget.task.options[_slotOptionIndices[i]!]),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
      ],
    );
  }

  Widget _buildOptions() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        for (var i = 0; i < widget.task.options.length; i++)
          Visibility(
            key: ValueKey(i),
            visible: !_usedOptionIndices.contains(i),
            maintainState: true,
            child: _buildOptionButton(i),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return TaskInteractionLayout(
      scrollable: widget.interactionScrollable,
      content: Column(
        mainAxisSize: MainAxisSize.min,

        children: [
          _buildOptions(),
          const SizedBox(height: AppSpacing.md),

          // Тимчасова область для майбутнього падіння елементів.
          const SizedBox(height: 160),

          _buildSlots(),
        ],
      ),
    );
  }

  String _displayText(Object? value) {
    if (value is AudioLinkedContent) {
      return _displayText(value.content);
    }

    if (value is TextContent) {
      return value.text;
    }

    if (value is EmojiContent) {
      return value.emoji;
    }

    return value.toString();
  }

  Widget _buildOptionButton(int index) {
    final option = widget.task.options[index];

    final button = ChoiceAnswerButton(
      answer: _displayText(option),
      state: TaskAnswerState.neutral,
      isSelected: false,
      onPressed: _isAnswered ? null : () => _onOptionSelected(index),
      buttonConfig: widget.task.buttonConfig,
    );

    if (option is! AudioLinkedContent) {
      return button;
    }

    return TaskAudioWidget(
      content: option.audio,
      isActive: _activeAudioOption == option,
      interactive: false,
      showIcon: false,
      onCompleted: () {
        if (!mounted || _activeAudioOption != option) return;

        setState(() {
          _activeAudioOption = null;
        });
      },
      child: button,
    );
  }
}
