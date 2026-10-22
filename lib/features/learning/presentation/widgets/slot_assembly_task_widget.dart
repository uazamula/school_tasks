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
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_option_bubble.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_options_area.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_slots.dart';
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
    with TickerProviderStateMixin {
  late List<int?> _slotOptionIndices;

  final Set<int> _usedOptionIndices = {};
  final Set<int> _attemptedSlots = {};
  final Set<int> _firstAttemptCorrectSlots = {};

  late final AnimationController _flightController;

  OverlayEntry? _flightOverlayEntry;

  Rect? _flightStartRect;
  Rect? _flightEndRect;

  String? _flightText;
  Color? _flightColor;

  bool _isFlying = false;

  int _correctSlotsCount = 0;
  AudioLinkedContent? _activeAudioOption;
  final Map<int, AudioPlaybackController> _audioControllers = {};
  Future<void>? _pendingAudioPlayback;

  late final AnimationController _fallController;
  late List<GlobalKey> _slotKeys;

  int? _fallingOptionIndex;
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
    _slotKeys = List.generate(
      widget.task.correctAnswers.length,
      (_) => GlobalKey(),
    );
    _fallController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _fallController.dispose();
    _flightController.dispose();
    _removeFlightOverlay();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SlotAssemblyTaskWidget<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _slotKeys = List.generate(
        widget.task.correctAnswers.length,
        (_) => GlobalKey(),
      );

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

  void _removeFlightOverlay() {
    _flightOverlayEntry?.remove();
    _flightOverlayEntry?.dispose();
    _flightOverlayEntry = null;
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

    final targetSlot = _findTargetSlot(optionIndex);

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
    return SlotAssemblySlots(
      slotKeys: _slotKeys,
      slots: [
        for (var i = 0; i < _slotOptionIndices.length; i++)
          _slotOptionIndices[i] == null
              ? '___'
              : _displayText(widget.task.options[_slotOptionIndices[i]!]),
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

  Future<void> _onFallingOptionTapped(
    int optionIndex,
    Rect sourceRect,
    Color bubbleColor,
  ) async {
    if (!mounted || _isAnswered || _isFinishing || _isFlying) {
      return;
    }

    _fallController.stop();
    _fallingOptionIndex = null;

    final targetSlot = _findTargetSlot(optionIndex);

    if (targetSlot == null) {
      // Неправильна відповідь: зберігаємо попередню поведінку.
      _onOptionSelected(optionIndex);

      if (!mounted || _isAnswered || _isFinishing) {
        return;
      }

      final nextIndex = _usedOptionIndices.contains(optionIndex)
          ? _nextFallingOptionIndex()
          : optionIndex;

      if (nextIndex != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _startFalling(nextIndex);
          }
        });
      }

      return;
    }

    await _animateOptionToSlot(
      optionIndex: optionIndex,
      targetSlot: targetSlot,
      sourceRect: sourceRect,
      color: bubbleColor,
    );

    if (!mounted || _isAnswered || _isFinishing) {
      return;
    }

    // Фіксуємо відповідь лише після завершення польоту.
    _onOptionSelected(optionIndex);

    if (!mounted || _isAnswered || _isFinishing) {
      return;
    }

    final nextIndex = _nextFallingOptionIndex();

    if (nextIndex != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _startFalling(nextIndex);
        }
      });
    }
  }

  Widget _buildFallingArea() {
    final optionIndex = _fallingOptionIndex;

    return FallingOptionsArea(
      animation: _fallController,
      optionIndex: optionIndex,
      text: optionIndex == null
          ? null
          : _displayText(widget.task.options[optionIndex]),
      canStart: !_isAnswered && !_isFinishing,
      onStartFalling: _startFalling,
      onOptionTapped: _onFallingOptionTapped,
      colorSeed: widget.task,
    );
  }

  int? _findTargetSlot(int optionIndex) {
    final option = widget.task.options[optionIndex];
    final nextEmptySlot = _nextEmptySlot();

    if (nextEmptySlot == null) {
      return null;
    }

    if (_requiresSequentialSelection) {
      return widget.task.correctAnswers[nextEmptySlot] == option
          ? nextEmptySlot
          : null;
    }

    return _findMatchingEmptySlot(option);
  }

  Rect? _getSlotRect(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _slotKeys.length) {
      return null;
    }

    final context = _slotKeys[slotIndex].currentContext;
    final renderObject = context?.findRenderObject();

    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return null;
    }

    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  Future<void> _animateOptionToSlot({
    required int optionIndex,
    required int targetSlot,
    required Rect sourceRect,
    required Color color,
  }) async {
    final targetGlobalRect = _getSlotRect(targetSlot);

    if (targetGlobalRect == null) {
      return;
    }

    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayObject = overlay.context.findRenderObject();

    if (overlayObject is! RenderBox ||
        !overlayObject.hasSize ||
        !overlayObject.attached) {
      return;
    }

    final startTopLeft = overlayObject.globalToLocal(sourceRect.topLeft);

    final targetCenter = overlayObject.globalToLocal(targetGlobalRect.center);

    _flightStartRect = startTopLeft & sourceRect.size;

    _flightEndRect = Rect.fromCenter(
      center: targetCenter,
      width: sourceRect.width,
      height: sourceRect.height,
    );

    _flightText = _displayText(widget.task.options[optionIndex]);

    _flightColor = color;
    _isFlying = true;

    _flightController.reset();

    final entry = OverlayEntry(
      builder: (overlayContext) {
        return AnimatedBuilder(
          animation: _flightController,
          builder: (context, child) {
            final rect = Rect.lerp(
              _flightStartRect!,
              _flightEndRect!,
              _flightController.value,
            )!;

            return Positioned.fromRect(
              rect: rect,
              child: FallingOptionBubble(
                text: _flightText!,
                color: _flightColor!,
                size: sourceRect.width,
                onTap: () {},
              ),
            );
          },
        );
      },
    );

    _flightOverlayEntry = entry;
    overlay.insert(entry);

    var completed = false;

    try {
      await _flightController.forward().orCancel;
      completed = true;
    } on TickerCanceled {
      // Анімацію перервано, наприклад під час знищення віджета.
    } finally {
      _removeFlightOverlay();

      if (!mounted) {
        return;
      }

      _isFlying = false;

      if (completed) {
        // Наступним кроком тут зафіксуємо відповідь
        // і відновимо падіння наступної бульбашки.
      }
    }
  }
}
