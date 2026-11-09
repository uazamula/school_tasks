import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/streak_progress.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/audio_content.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_answer.dart';
import 'package:school_tasks/features/learning/domain/tasks/content/memory_pair.dart';
import 'package:school_tasks/features/learning/domain/tasks/memory_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_answer_state.dart';
import 'package:school_tasks/features/learning/presentation/widgets/memory/memory_board_layout.dart';
import 'package:school_tasks/features/learning/presentation/widgets/memory/memory_card_view.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_audio_widget.dart';

enum _Phase { idle, bRevealing, awaitingA, resolving, boardChange }

class _BoardCard {
  _BoardCard({required this.pair, required this.isB, required this.ordinal});

  final MemoryPair pair;
  final bool isB;
  final int ordinal;

  bool showBack = false;
  bool removed = false;
  int shakeToken = 0;
}

class MemoryTaskWidget extends StatefulWidget {
  const MemoryTaskWidget({
    super.key,
    required this.task,
    required this.onTaskAnswered,
    required this.onProgressStep,
    required this.onCorrectPair,
    required this.onIncorrectPair,
    required this.onIncorrectPairAttempt,
    required this.onAccuracyChanged,
    required this.feedbackEnabled,
    this.onStreakChanged,
    this.paused = false,
  });

  final bool paused;
  final MemoryTask task;
  final ValueChanged<TaskResult<MemoryAnswer, List<MemoryPair>>> onTaskAnswered;
  final VoidCallback onProgressStep;
  final VoidCallback onCorrectPair;
  final VoidCallback onIncorrectPair;
  final bool Function() onIncorrectPairAttempt;
  final ValueChanged<AccuracyResult> onAccuracyChanged;
  final bool feedbackEnabled;
  final ValueChanged<StreakProgress>? onStreakChanged;

  @override
  State<MemoryTaskWidget> createState() => _MemoryTaskWidgetState();
}

class _MemoryTaskWidgetState extends State<MemoryTaskWidget> {
  static const _boardChangeDelay = Duration(milliseconds: 300);
  static const _boardFadeIn = Duration(milliseconds: 300);

  final Random _random = Random();
  final AudioPlaybackController _audioController = AudioPlaybackController();

  late List<_BoardCard> _cards;
  final Set<String> _failedPairIds = {};
  final Set<String> _firstAttemptCorrectPairIds = {};

  _Phase _phase = _Phase.idle;
  _BoardCard? _selectedB;

  Timer? _peekTimer;
  int _epoch = 0;
  int _peekRun = 0;
  int _boardGeneration = 0;

  bool _stopped = false;
  bool _isFinishing = false;

  StreakProgress _streak = const StreakProgress();

  AudioContent? _audioContent;
  Future<void>? _lastPlayback;

  MemoryTask get _task => widget.task;

  bool get _isEndless => _task.isEndless;

  @override
  void initState() {
    super.initState();
    _cards = _createCards(_initialPairs());
  }

  @override
  void didUpdateWidget(covariant MemoryTaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.task != widget.task) {
      _peekTimer?.cancel();
      _epoch++;
      _phase = _Phase.idle;
      _selectedB = null;
      _stopped = false;
      _isFinishing = false;
      _streak = const StreakProgress();
      _failedPairIds.clear();
      _firstAttemptCorrectPairIds.clear();
      _boardGeneration++;
      _cards = _createCards(_initialPairs());
    }
    if (oldWidget.task == widget.task && oldWidget.paused != widget.paused) {
      if (widget.paused) {
        _peekTimer?.cancel();
      } else if (_phase == _Phase.awaitingA) {
        // Показ B відновлюється з повною тривалістю.
        _startPeekTimer();
      }
    }
  }

  @override
  void dispose() {
    _peekTimer?.cancel();
    _audioController.dispose();
    super.dispose();
  }

  List<MemoryPair> _initialPairs() =>
      _isEndless ? _task.boardSource!.nextBoard() : _task.pairs;

  List<_BoardCard> _createCards(List<MemoryPair> pairs) {
    final n = pairs.length;
    final separated = _task.config.separatedZones;

    List<int> shuffled(int count) =>
        List.generate(count, (i) => i)..shuffle(_random);

    final ordA = shuffled(n);
    final ordB = shuffled(n);
    final ordAll = shuffled(2 * n);

    return [
      for (var i = 0; i < n; i++)
        _BoardCard(
          pair: pairs[i],
          isB: false,
          ordinal: separated ? ordA[i] : ordAll[i],
        ),
      for (var i = 0; i < n; i++)
        _BoardCard(
          pair: pairs[i],
          isB: true,
          ordinal: separated ? ordB[i] : ordAll[n + i],
        ),
    ];
  }

  /// Чекає; false, якщо віджет зупинено, змінено або знищено.
  Future<bool> _wait(Duration duration) async {
    final epoch = _epoch;
    await Future<void>.delayed(duration);
    return mounted && !_stopped && epoch == _epoch;
  }

  // ---------------------------------------------------------------- taps

  Future<void> _onBTap(_BoardCard card) async {
    if (_stopped || _phase != _Phase.idle || card.removed || card.showBack) {
      return;
    }

    setState(() {
      _phase = _Phase.bRevealing;
      _selectedB = card;
      card.showBack = true;
    });

    if (_task.config.playAudioOnReveal) {
      _playAudioOf(card.pair);
    }

    if (!await _wait(_task.config.flipDuration)) return;

    setState(() => _phase = _Phase.awaitingA);
    _startPeekTimer();
  }

  Future<void> _onATap(_BoardCard card) async {
    final b = _selectedB;

    if (_stopped || _phase != _Phase.awaitingA || b == null || card.removed) {
      return;
    }

    _peekTimer?.cancel();

    final hasBack = card.pair.faceBack != null;

    setState(() {
      _phase = _Phase.resolving;
      if (hasBack) card.showBack = true;
    });

    final isCorrect = _task
        .checkAnswer(
          MemoryAnswer(hiddenPairId: b.pair.id!, facePairId: card.pair.id!),
        )
        .isCorrect;

    if (hasBack && !await _wait(_task.config.flipDuration)) return;
    if (_stopped) return;

    if (isCorrect) {
      await _resolveCorrect(b, card);
    } else {
      await _resolveWrong(b, card);
    }
  }

  // ------------------------------------------------------------ outcomes

  Future<void> _resolveCorrect(_BoardCard b, _BoardCard a) async {
    final pairId = b.pair.id!;
    final firstTry = !_failedPairIds.contains(pairId);

    if (_isEndless) {
      final previousBest = _streak.best;

      _streak = _streak.registerCorrect();
      widget.onStreakChanged?.call(_streak);
      _task.boardSource!.reportPairResult(pairId, failed: !firstTry);

      _reportGoalProgress(previousBest);
    } else {
      if (firstTry) _firstAttemptCorrectPairIds.add(pairId);

      widget.onAccuracyChanged(
        AccuracyResult(
          correct: _firstAttemptCorrectPairIds.length,
          total: _task.pairs.length,
        ),
      );
      widget.onProgressStep();
    }

    if (widget.feedbackEnabled) widget.onCorrectPair();

    if (_task.config.replayAudioOnMatch) {
      _playAudioOf(b.pair);
    }

    setState(() {
      b.removed = true;
      a.removed = true;
    });

    if (!await _wait(MemoryCardView.removeDuration)) return;

    _selectedB = null;

    if (_goalReached && !_task.continueAfterGoal) {
      await _finishGoal();
      return;
    }

    if (_cards.every((card) => card.removed)) {
      if (_isEndless) {
        await _nextBoard();
      } else {
        await _finishTask();
      }
      return;
    }

    setState(() => _phase = _Phase.idle);
  }

  bool get _goalReached {
    final goal = _task.targetStreak;
    return goal != null && _streak.best >= goal;
  }

  void _reportGoalProgress(int previousBest) {
    final goal = _task.targetStreak;
    if (goal == null) return;

    widget.onAccuracyChanged(
      AccuracyResult(correct: min(_streak.best, goal), total: goal),
    );

    // Один крок прогресу за кожне нове значення найкращої серії.
    if (_streak.best > previousBest && _streak.best <= goal) {
      widget.onProgressStep();
    }
  }

  Future<void> _finishGoal() {
    final goal = _task.targetStreak!;
    return _finishTask(
      accuracy: AccuracyResult(correct: goal, total: goal),
    );
  }

  Future<void> _resolveWrong(_BoardCard b, _BoardCard a) async {
    if (_registerError(b.pair)) {
      _stopped = true;
      return;
    }

    // Без зворотного боку картка A не показує вердикт: трусимо її.
    if (a.pair.faceBack == null) {
      setState(() => a.shakeToken++);
    }

    if (!await _wait(_task.config.mismatchDelay)) return;

    // Обидві картки повертаються разом. З цього моменту B знову активні,
    // а A лишаються заблокованими, бо фаза вже idle.
    setState(() {
      b.showBack = false;
      a.showBack = false;
      _selectedB = null;
      _phase = _Phase.idle;
    });
  }

  /// Реєструє помилку. true — досягнуто ліміту, спробу завершує сторінка.
  bool _registerError(MemoryPair pair) {
    _failedPairIds.add(pair.id!);

    if (_isEndless) {
      _streak = _streak.registerError();
      // Серія йде ДО onIncorrectPairAttempt: той виклик може синхронно
      // завершити спробу.
      widget.onStreakChanged?.call(_streak);
    }

    final shouldFinish = widget.onIncorrectPairAttempt();

    if (widget.feedbackEnabled) widget.onIncorrectPair();

    return shouldFinish;
  }

  void _startPeekTimer() {
    final duration = _task.config.peekDuration;
    if (duration == null) return;

    _peekTimer?.cancel();
    _peekRun++;
    _peekTimer = Timer(duration, _onPeekTimeout);
  }

  void _onPeekTimeout() {
    final b = _selectedB;

    if (!mounted ||
        _stopped ||
        widget.paused ||
        _phase != _Phase.awaitingA ||
        b == null) {
      return;
    }

    if (_task.config.timeoutCountsAsError && _registerError(b.pair)) {
      _stopped = true;
      return;
    }

    setState(() {
      b.showBack = false;
      _selectedB = null;
      _phase = _Phase.idle;
    });
  }

  // ------------------------------------------------------ board lifecycle

  Future<void> _nextBoard() async {
    setState(() => _phase = _Phase.boardChange);

    if (!await _wait(_boardChangeDelay)) return;

    final pairs = _task.boardSource!.nextBoard();

    setState(() {
      _failedPairIds.clear();
      _boardGeneration++;
      _cards = _createCards(pairs);
      _phase = _Phase.idle;
    });
  }

  Future<void> _finishTask({AccuracyResult? accuracy}) async {
    if (_isFinishing) return;
    _isFinishing = true;

    final result = TaskResult<MemoryAnswer, List<MemoryPair>>(
      state: TaskAnswerState.correct,
      accuracy:
          accuracy ??
          AccuracyResult(
            correct: _firstAttemptCorrectPairIds.length,
            total: _task.pairs.length,
          ),
    );

    final playback = _lastPlayback;

    if (playback != null) {
      try {
        // Не даємо аудіо заблокувати завершення назавжди.
        await playback.timeout(const Duration(seconds: 10));
      } catch (_) {}
    }

    if (!mounted) return;

    widget.onTaskAnswered(result);
  }

  // ---------------------------------------------------------------- audio

  void _playAudioOf(MemoryPair pair) {
    final audio = pair.effectiveAudio;
    if (audio == null) return;

    if (_audioContent != audio) {
      // Спершу оновлюємо content віджета, потім граємо.
      setState(() => _audioContent = audio);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _lastPlayback = _audioController.playAndWait();
      });
    } else {
      _lastPlayback = _audioController.playAndWait();
    }
  }

  // ---------------------------------------------------------------- build

  VoidCallback? _tapFor(_BoardCard card) {
    if (_stopped || widget.paused || card.removed) return null;
    if (card.isB) {
      return _phase == _Phase.idle && !card.showBack
          ? () => _onBTap(card)
          : null;
    }

    return _phase == _Phase.awaitingA ? () => _onATap(card) : null;
  }

  @override
  Widget build(BuildContext context) {
    final config = _task.config;

    return LayoutBuilder(
      builder: (context, constraints) {
        final available = Size(
          constraints.hasBoundedWidth
              ? constraints.maxWidth
              : MediaQuery.sizeOf(context).width,
          constraints.hasBoundedHeight
              ? constraints.maxHeight
              : double.infinity,
        );

        final layout = MemoryBoardLayout.compute(
          gridSize: config.gridSize,
          separatedZones: config.separatedZones,
          adaptiveOrientation: config.adaptiveOrientation,
          aspect: config.cardAspectRatio,
          maxCardSize: config.maxCardSize,
          zoneOrder: config.zoneOrder,
          available: available,
          spacing: AppSpacing.sm,
          zoneGap: AppSpacing.lg,
        );

        if (layout.cardSize.width <= 0) return const SizedBox.shrink();

        final audio = _audioContent;

        return Center(
          child: SizedBox(
            width: layout.boardSize.width,
            height: layout.boardSize.height,
            child: Stack(
              children: [
                TweenAnimationBuilder<double>(
                  key: ValueKey(_boardGeneration),
                  tween: Tween(
                    begin: _boardGeneration == 0 ? 1.0 : 0.0,
                    end: 1.0,
                  ),
                  duration: _boardFadeIn,
                  builder: (context, opacity, child) =>
                      Opacity(opacity: opacity, child: child),
                  child: Stack(
                    children: [
                      for (final card in _cards)
                        Positioned(
                          key: ValueKey('${card.pair.id}:${card.isB}'),
                          left: layout
                              .offsetOf(
                                separated: config.separatedZones,
                                isB: card.isB,
                                ordinal: card.ordinal,
                              )
                              .dx,
                          top: layout
                              .offsetOf(
                                separated: config.separatedZones,
                                isB: card.isB,
                                ordinal: card.ordinal,
                              )
                              .dy,
                          child: MemoryCardView(
                            pair: card.pair,
                            isB: card.isB,
                            size: layout.cardSize,
                            style: config.cardStyle,
                            flipDuration: config.flipDuration,
                            showBack: card.showBack,
                            removed: card.removed,
                            shakeToken: card.shakeToken,
                            onTap: _tapFor(card),
                            peekDuration: config.peekDuration,
                            peekActive:
                                _phase == _Phase.awaitingA &&
                                !widget.paused &&
                                identical(card, _selectedB),
                            peekRun: _peekRun,
                          ),
                        ),
                    ],
                  ),
                ),
                // Один плеєр на дошку, а не по одному на картку.
                if (audio != null)
                  TaskAudioWidget(
                    content: audio,
                    controller: _audioController,
                    interactive: false,
                    showIcon: false,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
