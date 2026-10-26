import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/task_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_linked_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction.dart';
import 'package:school_tasks/features/learning/domain/tasks/interactions/slot_assembly_interaction_mode.dart';
import 'package:school_tasks/features/learning/domain/tasks/slot_assembly_task.dart';
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
  final Set<int> _flyingOptionIndices = {};
  final Set<int> _temporarilyHiddenFallingOptions = {};
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

  bool _isFinishing = false;

  late List<GlobalKey> _optionKeys;

  static const List<Color> _bubbleColors = [
    Color(0xFF2879C7),
    Color(0xFF159B88),
    Color(0xFF8054C7),
    Color(0xFFD66B35),
    Color(0xFFC74770),
    Color(0xFF647D35),
  ];

  final Map<int, Color> _bubbleColorsByOption = {};

  Color _bubbleColorFor(int optionIndex) {
    return _bubbleColorsByOption.putIfAbsent(
      optionIndex,
      () => _bubbleColors[math.Random().nextInt(_bubbleColors.length)],
    );
  }

  int? _nextFallingOptionIndex() {
    for (var i = 0; i < widget.task.options.length; i++) {
      if (!_usedOptionIndices.contains(i)) {
        return i;
      }
    }

    return null;
  }

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
      duration: const Duration(seconds: 10),
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

    _flightController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
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
                _buildFallingArea(),
                _buildAudioControllerHosts(),
                const SizedBox(height: AppSpacing.md),
                _buildSlots(),
              ],
            )
          : SizedBox.expand(
              child: Column(
                children: [
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

  /// Спільна логіка правильного заповнення слота
  /// для натискання та перетягування.
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

    // У послідовному режимі можна заповнити лише
    // наступний порожній слот.
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
      slots: [
        for (var i = 0; i < _slotOptionIndices.length; i++)
          _slotOptionIndices[i] == null
              ? '___'
              : _displayText(widget.task.options[_slotOptionIndices[i]!]),
      ],
      dragEnabled: _isDragInteraction && !_isAnswered && !_isFinishing,
      occupiedSlots: [
        for (final optionIndex in _slotOptionIndices) optionIndex != null,
      ],
      onOptionDropped: _onOptionDropped,
    );
  }

  List<List<int>> _buildOptionRows(int itemCount) {
    if (itemCount == 0) return [];

    const maxColumns = 4;

    final rowCount = (itemCount + maxColumns - 1) ~/ maxColumns;
    final baseCount = itemCount ~/ rowCount;
    final extraCount = itemCount % rowCount;

    var index = 0;

    return List.generate(rowCount, (rowIndex) {
      final count = baseCount + (rowIndex < extraCount ? 1 : 0);
      final row = List.generate(count, (_) => index++);
      return row;
    });
  }

  Widget _buildOptions() {
    final rows = _buildOptionRows(widget.task.options.length);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var rowIndex = 0; rowIndex < rows.length; rowIndex++) ...[
          if (rowIndex > 0) const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (
                var columnIndex = 0;
                columnIndex < rows[rowIndex].length;
                columnIndex++
              ) ...[
                if (columnIndex > 0) const SizedBox(width: AppSpacing.md),
                _buildOptionSlot(rows[rowIndex][columnIndex]),
              ],
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildOptionSlot(int index) {
    final isVisible =
        !_usedOptionIndices.contains(index) &&
        !_flyingOptionIndices.contains(index);

    return Visibility(
      key: ValueKey(index),
      visible: isVisible,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: KeyedSubtree(
        key: _optionKeys[index],
        child: _buildOptionButton(index),
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

    final bubble = FallingOptionBubble(
      text: _displayText(option),
      color: _bubbleColorFor(index),
      size: 48,
      onTap: _isAnswered || !_isPressInteraction
          ? () {}
          : () => unawaited(_onStaticOptionTapped(index)),
    );

    Widget optionWidget = bubble;

    if (option is AudioLinkedContent) {
      final controller = _audioControllers.putIfAbsent(
        index,
        AudioPlaybackController.new,
      );

      optionWidget = TaskAudioWidget(
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
        child: bubble,
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
        child: FallingOptionBubble(
          text: _displayText(option),
          color: _bubbleColorFor(index),
          size: 48,
          onTap: () {},
        ),
      ),
      childWhenDragging: const SizedBox(width: 48, height: 48),
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

      if (mounted) {
        _isFlying = false;
      }
    }

    return completed && mounted;
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
      color: _bubbleColorFor(optionIndex),
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
