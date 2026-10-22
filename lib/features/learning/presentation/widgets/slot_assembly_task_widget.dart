import 'dart:async';

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
    this.onElementReachedEdge,
  });

  final SlotAssemblyTask<TOption> task;
  final TaskResult<List<TOption>, List<TOption>>? result;
  final ValueChanged<TaskResult<List<TOption>, List<TOption>>> onTaskAnswered;
  final ValueChanged<AccuracyResult> onAccuracyChanged;
  final bool interactionScrollable;
  final ValueChanged<int>? onCorrectSlotFilled;
  final bool Function() onIncorrectAttempt;
  final VoidCallback? onElementReachedEdge;

  @override
  State<SlotAssemblyTaskWidget<TOption>> createState() =>
      _SlotAssemblyTaskWidgetState<TOption>();
}

class _SlotAssemblyTaskWidgetState<TOption>
    extends State<SlotAssemblyTaskWidget<TOption>>
    with SingleTickerProviderStateMixin {
  late List<int?> _slotOptionIndices;

  final Set<int> _usedOptionIndices = {};
  final Set<int> _attemptedSlots = {};
  final Set<int> _firstAttemptCorrectSlots = {};
  int _correctSlotsCount = 0;
  AudioLinkedContent? _activeAudioOption;
  final Map<int, AudioPlaybackController> _audioControllers = {};
  Future<void>? _pendingAudioPlayback;

  static const double _fallingElementSize = 48;
  static const double _fallingAreaHeight = 360;

  late final AnimationController _fallController;

  int? _fallingOptionIndex;
  bool _fallingAreaStarted = false;
  bool _isFinishing = false;

  int? _nextFallingOptionIndex() {
    for (var i = 0; i < widget.task.options.length; i++) {
      if (!_usedOptionIndices.contains(i)) {
        return i;
      }
    }

    return null;
  }

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  bool get _requiresSequentialSelection =>
      (widget.task.interaction as SlotAssemblyInteraction)
          .requiresSequentialSelection;

  @override
  void initState() {
    super.initState();
    _resetSlots();
    _fallController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _fallController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          mounted &&
          widget.task.fallingElementsEnabled &&
          !_isAnswered &&
          !_isFinishing &&
          _fallingOptionIndex != null) {
        widget.onElementReachedEdge?.call();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _fallController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SlotAssemblyTaskWidget<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _resetSlots();
      _activeAudioOption = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return TaskInteractionLayout(
      scrollable: widget.interactionScrollable,
      alignment: Alignment.topCenter,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.task.fallingElementsEnabled)
            _buildFallingArea()
          else
            _buildOptions(),
          const SizedBox(height: AppSpacing.md),
          _buildSlots(),
        ],
      ),
    );
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
      if (option is AudioLinkedContent) {
        final playback = _audioControllers[optionIndex]?.playAndWait();

        if (playback != null) {
          _pendingAudioPlayback = playback;
        }
      }
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
      unawaited(_finishTask());
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

  Future<void> _finishTask() async {
    if (_isAnswered || _isFinishing) return;

    _isFinishing = true;

    final answer = <TOption>[
      for (final index in _slotOptionIndices) widget.task.options[index!],
    ];

    final checkedResult = widget.task.checkAnswer(answer);

    final result = TaskResult<List<TOption>, List<TOption>>(
      state: checkedResult.state,
      selectedAnswer: checkedResult.selectedAnswer,
      solution: checkedResult.solution,
      accuracy: AccuracyResult(
        correct: _firstAttemptCorrectSlots.length,
        total: widget.task.correctAnswers.length,
      ),
    );

    final playback = _pendingAudioPlayback;
    _pendingAudioPlayback = null;

    if (playback != null) {
      await playback;
    }

    if (!mounted) return;

    widget.onTaskAnswered(result);
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
    final controller = _audioControllers.putIfAbsent(
      index,
      AudioPlaybackController.new,
    );

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
      controller: controller,
      child: button,
    );
  }

  void _startFalling([int? optionIndex]) {
    if (!mounted ||
        _isAnswered ||
        _isFinishing ||
        !widget.task.fallingElementsEnabled) {
      return;
    }

    final index = optionIndex ?? _nextFallingOptionIndex();

    if (index == null) {
      return;
    }

    _fallController.stop();
    _fallController.value = 0;

    setState(() {
      _fallingOptionIndex = index;
    });

    _fallController.forward();
  }

  void _onFallingOptionTapped(int optionIndex) {
    if (_isAnswered || _isFinishing || _fallingOptionIndex != optionIndex) {
      return;
    }

    _fallController.stop();

    setState(() {
      _fallingOptionIndex = null;
    });

    _onOptionSelected(optionIndex);

    if (!mounted || _isAnswered || _isFinishing) {
      return;
    }

    // Якщо елемент правильний, він уже використаний,
    // тому наступним впаде інший доступний елемент.
    // Якщо відповідь неправильна, цей елемент можна
    // спробувати вибрати ще раз.
    final nextIndex = _usedOptionIndices.contains(optionIndex)
        ? _nextFallingOptionIndex()
        : optionIndex;

    if (nextIndex == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isAnswered && !_isFinishing) {
        _startFalling(nextIndex);
      }
    });
  }

  Widget _buildFallingArea() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: SizedBox(
        height: _fallingAreaHeight,
        width: 240,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (!_fallingAreaStarted) {
              _fallingAreaStarted = true;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_isAnswered && !_isFinishing) {
                  _startFalling();
                }
              });
            }

            return ClipRect(
              child: AnimatedBuilder(
                animation: _fallController,
                builder: (context, child) {
                  final optionIndex = _fallingOptionIndex;

                  if (optionIndex == null) {
                    return const SizedBox.expand();
                  }

                  final availableHeight =
                      (constraints.maxHeight - _fallingElementSize).clamp(
                        0.0,
                        double.infinity,
                      );

                  final top = availableHeight * _fallController.value;

                  return Stack(
                    alignment: Alignment.topLeft,
                    children: [
                      Positioned(
                        top: top,
                        left: (constraints.maxWidth - _fallingElementSize) / 2,
                        width: _fallingElementSize,
                        height: _fallingElementSize,
                        child: GestureDetector(
                          onTap: () => _onFallingOptionTapped(optionIndex),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(
                                _fallingElementSize / 2,
                              ),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    _displayText(
                                      widget.task.options[optionIndex],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
