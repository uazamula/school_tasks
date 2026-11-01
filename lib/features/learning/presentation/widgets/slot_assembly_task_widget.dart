import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/bubble_color_palette.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_option_bubble.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_options_area.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_audio.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_flight_animation.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_geometry.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_options.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_slots.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';

const nothing = '  ';

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
    this.showSlotHints,
  });

  final SlotAssemblyTask<TOption> task;
  final TaskResult<List<TOption>, List<TOption>>? result;
  final ValueChanged<TaskResult<List<TOption>, List<TOption>>> onTaskAnswered;
  final ValueChanged<AccuracyResult> onAccuracyChanged;
  final bool interactionScrollable;
  final ValueChanged<int>? onCorrectSlotFilled;
  final bool Function() onIncorrectAttempt;
  final VoidCallback? onElementReachedEdge;

  /// Ручне перемикання підказок у слотах (бліді/яскраві елементи).
  /// null — береться значення з task.uiConfig.showSlotHints.
  final bool? showSlotHints;

  @override
  State<SlotAssemblyTaskWidget<TOption>> createState() =>
      _SlotAssemblyTaskWidgetState<TOption>();
}

class _SlotAssemblyTaskWidgetState<TOption>
    extends State<SlotAssemblyTaskWidget<TOption>>
    with TickerProviderStateMixin {
  late SlotAssemblyState<TOption> _state;
  final Set<int> _flyingOptionIndices = {};
  final Set<int> _temporarilyHiddenFallingOptions = {};

  bool _isFlying = false;

  TOption? _activeAudioOption;
  final SlotAssemblyAudio _audio = SlotAssemblyAudio();

  late final AnimationController _fallController;
  late List<GlobalKey> _slotKeys;

  bool _isFinishing = false;

  late List<GlobalKey> _optionKeys;

  final GlobalKey<SlotAssemblyFlightAnimationState> _flightAnimationKey =
      GlobalKey<SlotAssemblyFlightAnimationState>();

  final BubbleColorPalette _bubbleColorPalette = BubbleColorPalette();

  int? _nextFallingOptionIndex() => _state.nextUnusedOptionIndex;

  double get _bubbleSize => widget.task.uiConfig.bubbleHeight;

  bool get _showSlotHints =>
      widget.showSlotHints ?? widget.task.uiConfig.showSlotHints;

  bool get _isAnswered => widget.result?.isAnswered ?? false;

  SlotAssemblyInteraction get _interaction =>
      widget.task.interaction as SlotAssemblyInteraction;

  SlotAssemblyInteractionMode get _interactionMode => _interaction.mode;

  PressForSlotInteractionMode? get _pressMode {
    final mode = _interactionMode;
    return mode is PressForSlotInteractionMode ? mode : null;
  }

  bool get _fallingElementsEnabled =>
      _pressMode?.fallingElementsEnabled ?? false;

  bool get _flightAnimationEnabled =>
      _pressMode?.flightAnimationEnabled ?? false;

  bool get _isPressInteraction => _pressMode != null;

  bool get _isDragInteraction => _interactionMode is DragToSlotInteractionMode;

  DragToSlotInteractionMode? get _dragMode {
    final interaction = widget.task.interaction;

    if (interaction is! SlotAssemblyInteraction) {
      return null;
    }

    final mode = interaction.mode;

    return mode is DragToSlotInteractionMode ? mode : null;
  }

  @override
  void initState() {
    super.initState();

    _resetSlots();

    _optionKeys = List.generate(widget.task.options.length, (_) => GlobalKey());

    _slotKeys = List.generate(
      widget.task.correctAnswers.length,
      (_) => GlobalKey(),
    );

    _fallController = AnimationController(
      vsync: this,
      duration: _pressMode?.fallingDuration ?? const Duration(seconds: 10),
    );

    _fallController.addStatusListener((status) {
      if (status == AnimationStatus.completed &&
          mounted &&
          _fallingElementsEnabled &&
          !_isAnswered &&
          !_isFinishing &&
          !_isFlying &&
          _nextFallingOptionIndex() != null) {
        widget.onElementReachedEdge?.call();
      }
    });
  }

  @override
  void dispose() {
    _audio.dispose();
    _fallController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SlotAssemblyTaskWidget<TOption> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _optionKeys = List.generate(
        widget.task.options.length,
        (_) => GlobalKey(),
      );

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
    final fallingEnabled = _fallingElementsEnabled;

    return TaskInteractionLayout(
      scrollable: widget.interactionScrollable,
      alignment: Alignment.topCenter,
      fillAvailableSpace: !fallingEnabled,
      content: fallingEnabled
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildFlightAnimation(),
                _buildFallingArea(),
                _buildAudioControllerHosts(),
                const SizedBox(height: AppSpacing.md),
                _buildSlots(),
              ],
            )
          : SizedBox.expand(
              child: Column(
                children: [
                  _buildFlightAnimation(),
                  Align(alignment: Alignment.topCenter, child: _buildOptions()),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: UnconstrainedBox(
                      constrainedAxis: Axis.vertical,
                      child: _buildSlots(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildFlightAnimation() {
    return SlotAssemblyFlightAnimation(
      key: _flightAnimationKey,
      duration: _pressMode?.flightDuration ?? const Duration(milliseconds: 700),
    );
  }

  void _resetSlots() {
    _state = SlotAssemblyState<TOption>(
      options: widget.task.options,
      correctAnswers: widget.task.correctAnswers,
      requiresSequentialSelection: _interaction.requiresSequentialSelection,
    );

    _activeAudioOption = null;
    _temporarilyHiddenFallingOptions.clear();
  }

  /// Обробляє вибір варіанта в режимі натискання.
  void _onOptionSelected(int optionIndex, {bool playAudio = true}) {
    if (_isAnswered || _isFinishing || _state.isOptionUsed(optionIndex)) {
      return;
    }

    if (playAudio) {
      _playOptionAudio(optionIndex);
    }

    final nextEmptySlot = _state.nextEmptySlot;
    if (nextEmptySlot == null) return;

    final targetSlot = _state.findTargetSlot(optionIndex);

    if (targetSlot == null) {
      _recordIncorrectAttempt(nextEmptySlot);
      return;
    }

    _fillCorrectSlot(optionIndex, targetSlot);
  }

  /// Реєструє неправильну спробу для конкретного слота.
  void _recordIncorrectAttempt(int slotIndex) {
    if (_isAnswered || _isFinishing) return;

    setState(() => _state.recordIncorrectAttempt(slotIndex));

    widget.onIncorrectAttempt();
  }

  /// Спільна логіка правильного заповнення слота для натискання та перетягування.
  void _fillCorrectSlot(int optionIndex, int targetSlot) {
    if (_isAnswered ||
        _isFinishing ||
        !_state.canPlace(optionIndex, targetSlot)) {
      return;
    }

    setState(() => _state.place(optionIndex, targetSlot));

    widget.onCorrectSlotFilled?.call(_state.correctSlotsCount);
    _notifyAccuracy();

    if (_state.isComplete) {
      unawaited(_finishTask());
    }
  }

  /// Обробляє перетягування варіанта в конкретний слот.
  void _onOptionDropped(int optionIndex, int targetSlot) {
    if (!_isDragInteraction || _isAnswered || _isFinishing) return;

    switch (_state.classifyDrop(optionIndex, targetSlot)) {
      case DropOutcome.ignored:
        return;
      case DropOutcome.incorrect:
        _recordIncorrectAttempt(targetSlot);
        return;
      case DropOutcome.correct:
        _playOptionAudio(optionIndex);
        _fillCorrectSlot(optionIndex, targetSlot);
        return;
    }
  }

  void _notifyAccuracy() => widget.onAccuracyChanged(_state.accuracy);

  Future<void> _finishTask() async {
    if (_isAnswered || _isFinishing) return;

    _isFinishing = true;

    final answer = _state.answer;

    final checkedResult = widget.task.checkAnswer(answer);

    final result = TaskResult<List<TOption>, List<TOption>>(
      state: checkedResult.state,
      selectedAnswer: checkedResult.selectedAnswer,
      solution: checkedResult.solution,
      accuracy: _state.accuracy,
    );

    final playback = _audio.takePendingPlayback();

    if (playback != null) {
      try {
        await playback;
      } catch (error) {
        debugPrint('Audio playback failed: $error');
      }
    }

    if (!mounted) return;

    widget.onTaskAnswered(result);
  }

  Widget _buildSlots() {
    return SlotAssemblySlots(
      slotKeys: _slotKeys,
      uiConfig: widget.task.uiConfig,
      slots: [
        for (final optionIndex in _state.slotOptionIndices)
          optionIndex == null
              ? nothing
              : _displayText(widget.task.options[optionIndex]),
      ],
      dragEnabled: _isDragInteraction && !_isAnswered && !_isFinishing,
      occupiedSlots: [
        for (final optionIndex in _state.slotOptionIndices) optionIndex != null,
      ],
      onOptionDropped: _onOptionDropped,
      showHints: _showSlotHints,
      hints: [
        for (final answer in widget.task.correctAnswers) _displayText(answer),
      ],
    );
  }

  Widget _buildOptions() {
    return SlotAssemblyOptions(
      itemCount: _optionKeys.length,
      isOptionVisible: (index) =>
          !_state.isOptionUsed(index) && !_flyingOptionIndices.contains(index),
      optionKey: (index) => _optionKeys[index],
      optionBuilder: _buildOptionButton,
    );
  }

  String _displayText(Object? value) {
    if (value is TextContent) {
      return value.text;
    }

    if (value is EmojiContent) {
      return value.emoji;
    }

    return value.toString();
  }

  bool get _interactionLocked => _isAnswered || _isFinishing;

  Widget _buildBubble(
    int index, {
    VoidCallback? onPointerDown,
    VoidCallback? onTap,
  }) {
    return FallingOptionBubble(
      text: _displayText(widget.task.options[index]),
      color: _bubbleColorPalette.colorFor(index),
      size: _bubbleSize,
      fontSizeFactor: widget.task.uiConfig.bubbleFontSizeFactor,
      onPointerDown: onPointerDown,
      onTap: onTap ?? () {},
    );
  }

  Widget _buildDraggable(int index) {
    return Draggable<int>(
      data: index,
      maxSimultaneousDrags: _interactionLocked ? 0 : 1,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: _dragMode?.dragScale ?? 1.0,
          child: _buildBubble(index),
        ),
      ),
      childWhenDragging: SizedBox(width: _bubbleSize, height: _bubbleSize),
      child: _buildBubble(
        index,
        onPointerDown: _interactionLocked ? null : () => _audio.toggle(index),
      ),
    );
  }

  Widget _buildOptionButton(int index) {
    final option = widget.task.options[index];
    final audio = SlotAssemblyAudio.audioFor(option);

    final child = _isDragInteraction
        ? _buildDraggable(index)
        : _buildBubble(
            index,
            onTap: _isAnswered
                ? null
                : () {
                    if (_isPressInteraction) {
                      unawaited(_onStaticOptionTapped(index));
                    }
                  },
          );

    if (audio == null) return child;

    return TaskAudioWidget(
      content: audio,
      isActive: _activeAudioOption == option,
      interactive: false,
      showIcon: false,
      onCompleted: () {
        if (!mounted || _activeAudioOption != option) return;
        setState(() => _activeAudioOption = null);
      },
      controller: _audio.controllerFor(index),
      child: child,
    );
  }

  void _startFalling() {
    if (!mounted ||
        _isAnswered ||
        _isFinishing ||
        !_fallingElementsEnabled ||
        _nextFallingOptionIndex() == null) {
      return;
    }

    _fallController
      ..stop()
      ..value = 0
      ..forward();
  }

  Future<void> _onFallingOptionTapped(
    int optionIndex,
    Rect sourceRect,
    Color bubbleColor,
  ) async {
    if (!mounted ||
        _isAnswered ||
        _isFinishing ||
        _isFlying ||
        _temporarilyHiddenFallingOptions.contains(optionIndex) ||
        _state.isOptionUsed(optionIndex)) {
      return;
    }

    setState(() {
      _temporarilyHiddenFallingOptions.add(optionIndex);
    });

    final targetSlot = _state.findTargetSlot(optionIndex);

    if (targetSlot == null) {
      // Неправильна відповідь: облік спроб залишається незмінним.
      _onOptionSelected(optionIndex);

      if (mounted) {
        setState(() {
          _temporarilyHiddenFallingOptions.remove(optionIndex);
        });
      }

      return;
    }

    if (_flightAnimationEnabled) {
      final completed = await _animateOptionToSlot(
        optionIndex: optionIndex,
        targetSlot: targetSlot,
        sourceRect: sourceRect,
        color: bubbleColor,
      );

      if (!mounted || _isAnswered || _isFinishing) {
        return;
      }

      if (!completed) {
        // Якщо анімація не відбулася, не втрачаємо правильну відповідь.
        _onOptionSelected(optionIndex);

        setState(() {
          _temporarilyHiddenFallingOptions.remove(optionIndex);
        });

        return;
      }
    }
    // За вимкненої анімації слот заповнюється одразу.
    _onOptionSelected(optionIndex);

    if (mounted) {
      setState(() {
        _temporarilyHiddenFallingOptions.remove(optionIndex);
      });
    }
  }

  Widget _buildFallingArea() {
    final optionIndices = [
      for (var i = 0; i < widget.task.options.length; i++) i,
    ];

    return FallingOptionsArea(
      animation: _fallController,
      optionIndices: optionIndices,
      textForOption: (index) => _displayText(widget.task.options[index]),
      uiConfig: widget.task.uiConfig,
      elementSize: _bubbleSize,
      hiddenOptionIndices: {
        ..._state.usedOptionIndices,
        ..._temporarilyHiddenFallingOptions,
      },
      canStart: !_isAnswered && !_isFinishing,
      onStartFalling: _startFalling,
      onOptionTapped: _onFallingOptionTapped,
      colorSeed: widget.task,
    );
  }

  Rect? _getSlotRect(int slotIndex) {
    if (slotIndex < 0 || slotIndex >= _slotKeys.length) return null;

    return globalRectOfKey(_slotKeys[slotIndex]);
  }

  Future<bool> _animateOptionToSlot({
    required int optionIndex,
    required int targetSlot,
    required Rect sourceRect,
    required Color color,
  }) async {
    final targetGlobalRect = _getSlotRect(targetSlot);

    if (targetGlobalRect == null) {
      return false;
    }

    final rects = computeFlightRects(
      context,
      sourceRect: sourceRect,
      targetRect: targetGlobalRect,
    );

    if (rects == null) {
      return false;
    }

    _isFlying = true;

    try {
      final animation = _flightAnimationKey.currentState;

      if (animation == null) {
        return false;
      }

      return await animation.animate(
        startRect: rects.start,
        endRect: rects.end,
        text: _displayText(widget.task.options[optionIndex]),
        color: color,
      );
    } finally {
      if (mounted) {
        _isFlying = false;
      }
    }
  }

  Widget _buildAudioControllerHosts() {
    return Offstage(
      offstage: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < widget.task.options.length; index++)
            if (SlotAssemblyAudio.audioFor(widget.task.options[index])
                case final audio?)
              TaskAudioWidget(
                content: audio,
                interactive: false,
                showIcon: false,
                isActive: false,
                controller: _audio.controllerFor(index),
              ),
        ],
      ),
    );
  }

  Rect? _getOptionRect(int optionIndex) {
    if (optionIndex < 0 || optionIndex >= _optionKeys.length) return null;

    return globalRectOfKey(_optionKeys[optionIndex]);
  }

  void _playOptionAudio(int optionIndex) {
    _audio.play(optionIndex, widget.task.options[optionIndex]);
  }

  Future<void> _onStaticOptionTapped(int optionIndex) async {
    if (!_isPressInteraction ||
        _isAnswered ||
        _isFinishing ||
        _isFlying ||
        _state.isOptionUsed(optionIndex)) {
      return;
    }
    // Аудіо запускається одразу після натискання.
    _playOptionAudio(optionIndex);

    final targetSlot = _state.findTargetSlot(optionIndex);
    // Для неправильної відповіді зберігаємо попередню поведінку.
    if (targetSlot == null) {
      _onOptionSelected(optionIndex, playAudio: false);
      return;
    }
    // Без анімації заповнюємо слот одразу.
    if (!_flightAnimationEnabled) {
      _onOptionSelected(optionIndex, playAudio: false);
      return;
    }

    final sourceRect = _getOptionRect(optionIndex);
    // Якщо координати недоступні, не блокуємо відповідь.
    if (sourceRect == null) {
      _onOptionSelected(optionIndex, playAudio: false);
      return;
    }

    setState(() {
      _flyingOptionIndices.add(optionIndex);
    });

    final completed = await _animateOptionToSlot(
      optionIndex: optionIndex,
      targetSlot: targetSlot,
      sourceRect: sourceRect,
      color: _bubbleColorPalette.colorFor(optionIndex),
    );

    if (!mounted) return;

    setState(() {
      _flyingOptionIndices.remove(optionIndex);
    });

    if (!completed ||
        _isAnswered ||
        _isFinishing ||
        _state.isOptionUsed(optionIndex)) {
      return;
    }
    // Фіксуємо відповідь лише після завершення польоту.
    _onOptionSelected(optionIndex, playAudio: false);
  }
}
