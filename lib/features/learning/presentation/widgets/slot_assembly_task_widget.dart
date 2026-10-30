import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/bubble_color_palette.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_option_bubble.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/falling_options_area.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_flight_animation.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_options.dart';
import 'package:school_tasks/features/learning/presentation/widgets/slot_assembly/slot_assembly_slots.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_interaction_layout.dart';

var nothing = '  ';

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
  final Set<int> _flyingOptionIndices = {};
  final Set<int> _temporarilyHiddenFallingOptions = {};
  final Set<int> _attemptedSlots = {};
  final Set<int> _firstAttemptCorrectSlots = {};

  bool _isFlying = false;

  int _correctSlotsCount = 0;
  AudioLinkedContent? _activeAudioOption;
  final Map<int, AudioPlaybackController> _audioControllers = {};
  Future<void>? _pendingAudioPlayback;

  late final AnimationController _fallController;
  late List<GlobalKey> _slotKeys;

  bool _isFinishing = false;

  late List<GlobalKey> _optionKeys;

  final GlobalKey<SlotAssemblyFlightAnimationState> _flightAnimationKey =
      GlobalKey<SlotAssemblyFlightAnimationState>();

  final BubbleColorPalette _bubbleColorPalette = BubbleColorPalette();

  int? _nextFallingOptionIndex() {
    for (var i = 0; i < widget.task.options.length; i++) {
      if (!_usedOptionIndices.contains(i)) {
        return i;
      }
    }

    return null;
  }

  double get _bubbleSize => widget.task.uiConfig.bubbleHeight;

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

  bool get _requiresSequentialSelection =>
      _interaction.requiresSequentialSelection;

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
      duration: _pressMode?.fallingDuration ??
          const Duration(seconds: 10),
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
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: Color(0xFFFF0000))),
        child: fallingEnabled
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SlotAssemblyFlightAnimation(
                    key: _flightAnimationKey,
                    duration: _pressMode?.flightDuration ??
                        const Duration(milliseconds: 700),
                  ),
                  _buildFallingArea(),
                  _buildAudioControllerHosts(),
                  const SizedBox(height: AppSpacing.md),
                  _buildSlots(),
                ],
              )
            : SizedBox.expand(
                child: Column(
                  children: [
                    SlotAssemblyFlightAnimation(
                      key: _flightAnimationKey,
                      duration: _pressMode?.flightDuration ??
                          const Duration(milliseconds: 700),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: _buildOptions(),
                    ),
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
    _temporarilyHiddenFallingOptions.clear();
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

  /// Обробляє вибір варіанта в режимі натискання.
  void _onOptionSelected(int optionIndex, {bool playAudio = true}) {
    if (_isAnswered ||
        _isFinishing ||
        _usedOptionIndices.contains(optionIndex)) {
      return;
    }

    if (playAudio) {
      _playOptionAudio(optionIndex);
    }

    final nextEmptySlot = _nextEmptySlot();
    if (nextEmptySlot == null) return;

    final targetSlot = _findTargetSlot(optionIndex);

    if (targetSlot == null) {
      _recordIncorrectAttempt(nextEmptySlot);
      return;
    }

    _fillCorrectSlot(optionIndex, targetSlot);
  }

  /// Реєструє неправильну спробу для конкретного слота.
  void _recordIncorrectAttempt(int slotIndex) {
    if (_isAnswered || _isFinishing) return;

    setState(() {
      _attemptedSlots.add(slotIndex);
    });

    widget.onIncorrectAttempt();
  }

  /// Спільна логіка правильного заповнення слота для натискання та перетягування.
  void _fillCorrectSlot(int optionIndex, int targetSlot) {
    if (_isAnswered ||
        _isFinishing ||
        optionIndex < 0 ||
        optionIndex >= widget.task.options.length ||
        targetSlot < 0 ||
        targetSlot >= _slotOptionIndices.length ||
        _usedOptionIndices.contains(optionIndex) ||
        _slotOptionIndices[targetSlot] != null) {
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

  /// Обробляє перетягування варіанта в конкретний слот.
  void _onOptionDropped(int optionIndex, int targetSlot) {
    if (!_isDragInteraction ||
        _isAnswered ||
        _isFinishing ||
        optionIndex < 0 ||
        optionIndex >= widget.task.options.length ||
        targetSlot < 0 ||
        targetSlot >= _slotOptionIndices.length ||
        _usedOptionIndices.contains(optionIndex) ||
        _slotOptionIndices[targetSlot] != null) {
      return;
    }

    final nextEmptySlot = _nextEmptySlot();
    if (nextEmptySlot == null) return;
    // У послідовному режимі можна заповнити лише наступний порожній слот.
    if (_requiresSequentialSelection && targetSlot != nextEmptySlot) {
      _recordIncorrectAttempt(targetSlot);
      return;
    }

    final option = widget.task.options[optionIndex];
    final isCorrect = widget.task.correctAnswers[targetSlot] == option;

    if (!isCorrect) {
      _recordIncorrectAttempt(targetSlot);
      return;
    }

    _playOptionAudio(optionIndex);
    _fillCorrectSlot(optionIndex, targetSlot);
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
      uiConfig: widget.task.uiConfig,
      slots: [
        for (var i = 0; i < _slotOptionIndices.length; i++)
          _slotOptionIndices[i] == null
              ? nothing
              : _displayText(widget.task.options[_slotOptionIndices[i]!]),
      ],
      dragEnabled: _isDragInteraction && !_isAnswered && !_isFinishing,
      occupiedSlots: [
        for (final optionIndex in _slotOptionIndices) optionIndex != null,
      ],
      onOptionDropped: _onOptionDropped,
    );
  }

  Widget _buildOptions() {
    return SlotAssemblyOptions(
      itemCount: _optionKeys.length,
      isOptionVisible: (index) =>
          !_usedOptionIndices.contains(index) &&
          !_flyingOptionIndices.contains(index),
      optionKey: (index) => _optionKeys[index],
      optionBuilder: _buildOptionButton,
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

    final bubble = FallingOptionBubble(
      text: _displayText(option),
      color: _bubbleColorPalette.colorFor(index),
      size: _bubbleSize,
      fontSizeFactor: widget.task.uiConfig.bubbleFontSizeFactor,
      onPointerDown: _isAnswered || _isFinishing
          ? null
          : () {
              if (_isDragInteraction && option is AudioLinkedContent) {
                _audioControllers[index]?.toggle();
              }
            },
      onTap: _isAnswered
          ? () {}
          : () {
              if (_isPressInteraction) {
                unawaited(_onStaticOptionTapped(index));
              }
            },
    );

    Widget optionWidget = bubble;

    if (option is AudioLinkedContent) {
      final controller = _audioControllers.putIfAbsent(
        index,
        AudioPlaybackController.new,
      );

      final audioWidget = TaskAudioWidget(
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
        child: _isDragInteraction
            ? SizedBox(width: _bubbleSize, height: _bubbleSize)
            : bubble,
      );

      if (!_isDragInteraction) {
        return audioWidget;
      }

      return Stack(
        alignment: Alignment.center,
        children: [
          // Аудіовіджет залишається поза піддеревом Draggable.
          Positioned.fill(child: IgnorePointer(child: audioWidget)),
          Draggable<int>(
            data: index,
            maxSimultaneousDrags: _isAnswered || _isFinishing ? 0 : 1,
            feedback: Material(
              color: Colors.transparent,
              child: Transform.scale(
                scale: _dragMode?.dragScale ?? 1.0,
                child: FallingOptionBubble(
                  text: _displayText(option),
                  color: _bubbleColorPalette.colorFor(index),
                  size: _bubbleSize,
                  fontSizeFactor: widget.task.uiConfig.bubbleFontSizeFactor,
                  onTap: () {},
                ),
              ),
            ),
            childWhenDragging: SizedBox(
              width: _bubbleSize,
              height: _bubbleSize,
            ),
            child: FallingOptionBubble(
              text: _displayText(option),
              color: _bubbleColorPalette.colorFor(index),
              size: _bubbleSize,
              fontSizeFactor: widget.task.uiConfig.bubbleFontSizeFactor,
              onPointerDown: _isAnswered || _isFinishing
                  ? null
                  : () => controller.toggle(),
              onTap: () {},
            ),
          ),
        ],
      );
    }

    if (!_isDragInteraction) {
      return optionWidget;
    }

    return Draggable<int>(
      data: index,
      maxSimultaneousDrags: _isAnswered || _isFinishing ? 0 : 1,
      feedback: Material(
        color: Colors.transparent,
        child: Transform.scale(
          scale: _dragMode?.dragScale ?? 1.0,
          child: FallingOptionBubble(
            text: _displayText(option),
            color: _bubbleColorPalette.colorFor(index),
            size: _bubbleSize,
            fontSizeFactor: widget.task.uiConfig.bubbleFontSizeFactor,
            onTap: () {},
          ),
        ),
      ),
      childWhenDragging: SizedBox(
        width: _bubbleSize,
        height: _bubbleSize,
      ),
      child: optionWidget,
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
        _usedOptionIndices.contains(optionIndex)) {
      return;
    }

    setState(() {
      _temporarilyHiddenFallingOptions.add(optionIndex);
    });

    final targetSlot = _findTargetSlot(optionIndex);

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
        ..._usedOptionIndices,
        ..._temporarilyHiddenFallingOptions,
      },
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

    final overlay = Overlay.of(context, rootOverlay: true);
    final overlayObject = overlay.context.findRenderObject();

    if (overlayObject is! RenderBox ||
        !overlayObject.hasSize ||
        !overlayObject.attached) {
      return false;
    }

    final startTopLeft = overlayObject.globalToLocal(sourceRect.topLeft);
    final targetCenter = overlayObject.globalToLocal(targetGlobalRect.center);

    final startRect = startTopLeft & sourceRect.size;

    final endRect = Rect.fromCenter(
      center: targetCenter,
      width: sourceRect.width,
      height: sourceRect.height,
    );

    _isFlying = true;

    try {
      final animation = _flightAnimationKey.currentState;

      if (animation == null) {
        return false;
      }

      return await animation.animate(
        startRect: startRect,
        endRect: endRect,
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
            if (widget.task.options[index] is AudioLinkedContent)
              TaskAudioWidget(
                content:
                    (widget.task.options[index] as AudioLinkedContent).audio,
                interactive: false,
                showIcon: false,
                isActive: false,
                controller: _audioControllers.putIfAbsent(
                  index,
                  AudioPlaybackController.new,
                ),
              ),
        ],
      ),
    );
  }

  Rect? _getOptionRect(int optionIndex) {
    if (optionIndex < 0 || optionIndex >= _optionKeys.length) {
      return null;
    }

    final context = _optionKeys[optionIndex].currentContext;
    final renderObject = context?.findRenderObject();

    if (renderObject is! RenderBox ||
        !renderObject.hasSize ||
        !renderObject.attached) {
      return null;
    }

    return renderObject.localToGlobal(Offset.zero) & renderObject.size;
  }

  void _playOptionAudio(int optionIndex) {
    final option = widget.task.options[optionIndex];

    if (option is! AudioLinkedContent) return;

    setState(() {
      final playback = _audioControllers[optionIndex]?.playAndWait();

      if (playback != null) {
        _pendingAudioPlayback = playback;
      }
    });
  }

  Future<void> _onStaticOptionTapped(int optionIndex) async {
    if (!_isPressInteraction ||
        _isAnswered ||
        _isFinishing ||
        _isFlying ||
        _usedOptionIndices.contains(optionIndex)) {
      return;
    }
    // Аудіо запускається одразу після натискання.
    _playOptionAudio(optionIndex);

    final targetSlot = _findTargetSlot(optionIndex);
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
        _usedOptionIndices.contains(optionIndex)) {
      return;
    }
    // Фіксуємо відповідь лише після завершення польоту.
    _onOptionSelected(optionIndex, playAudio: false);
  }
}
