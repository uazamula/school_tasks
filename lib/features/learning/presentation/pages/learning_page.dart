import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/preferences/preferences_provider.dart';
import 'package:school_tasks/core/services/audio/audio_service.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_generator.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_completion_reason.dart';
import 'package:school_tasks/features/learning/domain/evaluation/accuracy_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_calculator.dart';
import 'package:school_tasks/features/learning/domain/evaluation/streak_progress.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/memory_task.dart';
import 'package:school_tasks/features/learning/domain/tasks/task_progress.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/topic_result_kind.dart';
import 'package:school_tasks/features/learning/domain/topic_result_updater.dart';
import 'package:school_tasks/features/learning/presentation/widgets/failure_limit_indicator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_progress_indicator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/streak_indicator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_callbacks.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/topic_layout_widget.dart';
import 'package:school_tasks/features/learning/providers/learning_results_controller.dart';
import 'package:school_tasks/routing/app_router.dart';
import 'package:school_tasks/routing/app_routes.dart';

import '../../../../core/services/audio/audio_service_provider.dart';

class LearningPage extends ConsumerStatefulWidget {
  const LearningPage({
    super.key,
    required this.topicId,
    required this.exitGuard,
  });

  final String topicId;
  final LearningExitGuard exitGuard;

  @override
  ConsumerState<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends ConsumerState<LearningPage> {
  late final TopicAttempt _attempt;
  late final Topic _topic;

  final EvaluationCalculator _evaluationCalculator =
      const EvaluationCalculator();

  final TopicAttemptGenerator _attemptGenerator = TopicAttemptGenerator();

  final TopicResultUpdater _topicResultUpdater = const TopicResultUpdater();

  late final Stopwatch _stopwatch;

  int _failureCount = 0;

  int? get _failureLimit => _topic.automaticTermination?.failureLimit;

  AudioService get _audioService => ref.read(audioServiceProvider);

  Timer? _timer;
  Timer? _autoAdvanceTimer;

  int _completedProgressSteps = 0;
  bool _isFinishing = false;
  bool _hasSavedResult = false;

  int _targetProgress = 0;

  bool _isExitPaused = false;
  bool _resumeStopwatchAfterExit = false;

  bool get _pauseOnExitDialog =>
      _topic.automaticTermination?.pauseOnExitDialog ?? true;

  void _onCorrectSlotFilled(int progress) {
    if (!mounted) return;

    final addedSteps = progress - _targetProgress;

    setState(() {
      _targetProgress = progress;
      if (addedSteps > 0) {
        _completedProgressSteps += addedSteps;
      }
    });
  }

  late final MemoryTask? _endlessMemory = _findEndlessMemory();

  bool get _hasEndlessMemory => _endlessMemory != null;

  MemoryTask? _findEndlessMemory() {
    for (final attemptTask in _attempt.tasks) {
      final task = attemptTask.task;
      if (task is MemoryTask && task.isEndless) return task;
    }
    return null;
  }

  bool get _feedbackEnabled {
    return _topic.progressionMode != TopicProgressionMode.automatic;
  }

  bool _registerFailure() {
    final failureLimit = _failureLimit;

    setState(() {
      _failureCount++;
    });

    if (failureLimit == null) {
      return false;
    }

    return _failureCount >= failureLimit;
  }

  StreakProgress _streak = const StreakProgress();

  bool get _isStreakTopic => _topic.resultKind == TopicResultKind.streak;

  void _onStreakChanged(StreakProgress progress) {
    if (!mounted || _isFinishing) return;

    setState(() => _streak = progress);
  }

  @override
  void initState() {
    super.initState();

    _topic = LearningContent.getTopic(widget.topicId);
    _attempt = _attemptGenerator.generate(_topic);

    _stopwatch = Stopwatch()..start();

    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted || _isFinishing || _isExitPaused) {
        return;
      }

      final countdown = _topic.automaticTermination?.countdown;

      if (countdown != null && _stopwatch.elapsed >= countdown) {
        _handleTimeExpired();
        return;
      }

      setState(() {});
    });
    widget.exitGuard
      ..hasSavableProgress = _hasSavableProgress
      ..exitSummary = _exitSummary
      ..onExitDialogOpened = _pauseForExitDialog
      ..onExitDialogClosed = _resumeAfterExitDialog
      ..finishOnQuit = _finishOnQuit;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoAdvanceTimer?.cancel();
    _stopwatch.stop();
    widget.exitGuard.detach();
    super.dispose();
  }

  int get _totalProgressSteps =>
      totalProgressSteps(_attempt.tasks.map((attemptTask) => attemptTask.task));

  @override
  Widget build(BuildContext context) {
    final currentTask = _attempt.currentTask;
    final result = currentTask.result;

    final isManualAnswered =
        _topic.progressionMode == TopicProgressionMode.manual &&
        currentTask.isAnswered;

    final taskWidget = TaskWidget(
      task: currentTask.task,
      promptScrollable: _topic.layout.prompt.scrollable,
      result: result,
      feedbackEnabled: _feedbackEnabled,
      interactionScrollable: _topic.layout.interaction.scrollable,
      targetProgress: _targetProgress,
      callbacks: TaskCallbacks(
        onTaskAnswered: _onTaskAnswered,
        onProgressStep: _onProgressStep,
        onCorrectPair: _onCorrectPair,
        onIncorrectPair: _onIncorrectPair,
        onIncorrectPairAttempt: _onIncorrectPairAttempt,
        onAccuracyChanged: _onAccuracyChanged,
        onCorrectSlotFilled: _onCorrectSlotFilled,
        onElementReachedEdge: _handleElementReachedEdge,
        onStreakChanged: _onStreakChanged,
      ),
      paused: _isExitPaused,
    );

    return AppScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Transform.translate(
                  offset: const Offset(-8, 0),
                  child: IconButton(
                    onPressed: () {
                      rootNavigatorKey.currentState?.maybePop();
                    },
                    tooltip: 'Вийти',
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: _buildProgressIndicators(isManualAnswered),
                  ),
                ),
                if (_topic.dashboard.showStreak) ...[
                  const SizedBox(width: 12),
                  StreakIndicator(progress: _streak),
                ],
                if (_topic.dashboard.showRemainingAttempts) ...[
                  const SizedBox(width: 12),
                  FailureLimitIndicator(
                    failureLimit: _failureLimit,
                    failureCount: _failureCount,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TopicLayoutWidget(
                layout: _topic.layout,
                prompt: taskWidget.buildPrompt(),
                interaction: taskWidget.buildInteraction(),
                dimmed: isManualAnswered,
                promptOverlay: isManualAnswered
                    ? FilledButton(
                        onPressed: _attempt.isFinished
                            ? _finishAttempt
                            : _onManualNext,
                        child: Text(_attempt.isFinished ? 'Завершити' : 'Далі'),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildProgressIndicators(bool isManualAnswered) {
    final dashboard = _topic.dashboard;

    if (dashboard.showProgress && !_isStreakTopic) {
      return [
        Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: isManualAnswered ? 0.15 : 1.0,
            child: _buildProgressIndicator(showProgress: true),
          ),
        ),
      ];
    }

    if (dashboard.showTimer) {
      return [_buildProgressIndicator(showProgress: false)];
    }

    return const [];
  }

  Widget _buildProgressIndicator({required bool showProgress}) {
    return LearningProgressIndicator(
      progress: _completedProgressSteps,
      totalSteps: _totalProgressSteps,
      elapsed: _stopwatch.elapsed,
      maximumTime: _topic.automaticTermination?.countdown,
      showProgress: showProgress,
      showTimer: showProgress ? _topic.dashboard.showTimer : true,
    );
  }

  void _onProgressStep() {
    if (!mounted) {
      return;
    }

    setState(() {
      _completedProgressSteps++;
    });
  }

  void _onTaskAnswered(TaskResult<dynamic, dynamic> result) {
    final currentTask = _attempt.currentTask;

    if (currentTask.isAnswered) {
      return;
    }

    _attempt.recordResult(result);

    if (!result.isCorrect && _registerFailure()) {
      _handleFailureLimitReached();
      return;
    }

    // Matching і SlotAssembly озвучують кожну спробу окремо
    // (_onCorrectPair/_onIncorrectPair) і самі рахують прогрес.
    if (!reportsOwnProgress(currentTask.task)) {
      _playFeedback(isCorrect: result.isCorrect);
      _completedProgressSteps++;
    }

    switch (_topic.progressionMode) {
      case TopicProgressionMode.automatic:
        _moveAutomatically();
        return;

      case TopicProgressionMode.automaticWithFeedback:
        _showFeedbackAndAdvanceAutomatically();
        return;

      case TopicProgressionMode.manual:
        _showFeedbackAndWaitForManualNext();
        return;
    }
  }

  void _moveAutomatically() {
    if (_attempt.isFinished) {
      _markFinishing();

      _autoAdvanceTimer = Timer(
        LearningProgressIndicator.animationDuration,
        () {
          if (!mounted) {
            return;
          }

          _autoAdvanceTimer = null;
          _finishAttempt();
        },
      );

      return;
    }

    _moveToNextTask();
  }

  void _showFeedbackAndAdvanceAutomatically() {
    _stopwatch.stop();

    setState(() {});

    _autoAdvanceTimer?.cancel();

    _autoAdvanceTimer = Timer(_topic.feedbackDuration, () {
      if (!mounted) {
        return;
      }

      _autoAdvanceTimer = null;

      if (_attempt.isFinished) {
        _finishAttempt();
        return;
      }

      _moveToNextTask();
      _stopwatch.start();
    });
  }

  void _showFeedbackAndWaitForManualNext() {
    _stopwatch.stop();

    setState(() {});
  }

  void _onManualNext() {
    if (!mounted) {
      return;
    }

    _moveToNextTask();
    _stopwatch.start();
  }

  Future<void> _handleTimeExpired() async {
    if (_isFinishing) {
      return;
    }

    _markFinishing();

    if (!mounted) {
      return;
    }

    if (!_hasEndlessMemory) {
      await _showTimeExpiredDialog();
    }

    if (!mounted) {
      return;
    }

    await _finishAttempt(
      countdownExpired: true,
      completionReason: TopicCompletionReason.timeExpired,
    );
  }

  /// Позначає завершення: зупиняє таймери та секундомір.
  void _markFinishing() {
    _isFinishing = true;

    _timer?.cancel();
    _timer = null;

    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;

    _stopwatch.stop();
  }

  /// Витрачений час, не більший за countdown теми.
  Duration get _effectiveElapsed {
    final countdown = _topic.automaticTermination?.countdown;

    if (countdown != null && _stopwatch.elapsed >= countdown) {
      return countdown;
    }

    return _stopwatch.elapsed;
  }

  Future<void> _showTimeExpiredDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Час вичерпано'),
          content: const Text('Час на проходження теми завершено.'),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _finishAttempt({
    bool countdownExpired = false,
    TopicCompletionReason completionReason = TopicCompletionReason.completed,
  }) async {
    if (_hasSavedResult) {
      return;
    }

    _hasSavedResult = true;

    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;

    _stopwatch.stop();

    final elapsedTime = _effectiveElapsed;

    final topicResult = _attempt.getResult(duration: elapsedTime);

    final evaluation = _isStreakTopic
        ? null
        : _evaluationCalculator.calculate(
            topic: _topic,
            result: topicResult,
            elapsedTime: elapsedTime,
            countdownExpired: countdownExpired,
            failureCount: _failureCount,
          );

    final evaluatedResult = TopicAttemptResult(
      totalTasks: topicResult.totalTasks,
      completedTasks: topicResult.completedTasks,
      accuracy: topicResult.accuracy,
      duration: topicResult.duration,
      evaluation: evaluation,
      kind: _topic.resultKind,
      streak: _hasEndlessMemory ? _streak.best : null,
      pairsCompleted: _hasEndlessMemory ? _streak.pairs : null,
    );

    // Результат іншого виду (оцінка <-> серія) непорівнянний.
    final storedResult = ref.read(learningResultsControllerProvider)[_topic.id];
    final previousResult = storedResult?.kind == _topic.resultKind
        ? storedResult
        : null;

    final updatedResult = _topicResultUpdater.update(
      attempt: evaluatedResult,
      currentAt: DateTime.now(),
      previous: previousResult,
      completionReason: completionReason,
      failureCount: _failureCount,
    );

    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setTopicResult(_topic.id, updatedResult);

    if (!mounted) {
      return;
    }

    ref
        .read(learningResultsControllerProvider.notifier)
        .setResult(_topic.id, updatedResult);

    if (_hasEndlessMemory) {
      await _showEndlessResultDialog(
        previousBest: previousResult?.bestStreak ?? 0,
      );
      if (!mounted) return;
    }

    // Нормальне завершення теми — це дозволений вихід,
    // тому confirmation через onExit показувати не потрібно.
    widget.exitGuard.allowExit = true;

    if (kIsWeb) {
      Router.neglect(context, () => context.go(AppRoutes.home));
    } else {
      context.pop();
    }
  }

  Future<void> _showEndlessResultDialog({required int previousBest}) {
    final goal = _endlessMemory?.targetStreak;
    final goalReached = goal != null && _streak.best >= goal;
    final isNewRecord = goal == null && _streak.best > previousBest;
    final record = isNewRecord ? _streak.best : previousBest;

    final title = goalReached
        ? 'Мету досягнуто!'
        : isNewRecord
        ? 'Новий рекорд!'
        : 'Гру завершено';

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Серія в цій грі: ${_streak.best}'),
              if (goal != null)
                Text('Мета: $goal')
              else
                Text('Рекорд: $record'),
              Text('Пар складено: ${_streak.pairs}'),
            ],
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _moveToNextTask() {
    if (!mounted) {
      return;
    }

    setState(() {
      _targetProgress = 0;
      _attempt.moveToNextTask();
    });
  }

  void _onCorrectPair() => _playFeedback(isCorrect: true);

  void _onIncorrectPair() => _playFeedback(isCorrect: false);

  /// Звук вдачі/невдачі, якщо режим теми передбачає фідбек.
  void _playFeedback({required bool isCorrect}) {
    if (!_feedbackEnabled) {
      return;
    }

    if (isCorrect) {
      _audioService.playSuccess();
    } else {
      _audioService.playFailure();
    }
  }

  bool _onIncorrectPairAttempt() {
    if (!mounted || _isFinishing) {
      return true;
    }

    if (_registerFailure()) {
      _handleFailureLimitReached();
      return true;
    }

    return false;
  }

  Future<void> _handleFailureLimitReached() async {
    if (_isFinishing) {
      return;
    }

    _markFinishing();

    if (!mounted) {
      return;
    }

    await _finishAttempt(
      completionReason: TopicCompletionReason.failureLimitReached,
    );
  }

  void _onAccuracyChanged(AccuracyResult accuracy) {
    if (_isFinishing) return;

    final currentTask = _attempt.currentTask;
    if (currentTask.isAnswered || !reportsOwnProgress(currentTask.task)) return;

    _attempt.updateTaskAccuracy(_attempt.currentTaskIndex, accuracy);
  }

  void _handleElementReachedEdge() {
    if (!mounted || _isFinishing) return;

    _markFinishing();

    unawaited(
      _finishAttempt(
        completionReason: TopicCompletionReason.elementReachedEdge,
      ),
    );
  }

  bool _hasSavableProgress() {
    return _hasEndlessMemory &&
        !_isFinishing &&
        !_hasSavedResult &&
        _streak.pairs > 0;
  }

  String? _exitSummary() {
    final goal = _endlessMemory?.targetStreak;
    if (goal != null) return 'Серія в цій грі: ${_streak.best} із $goal';

    final stored = ref.read(learningResultsControllerProvider)[_topic.id];
    final previousBest = stored?.kind == _topic.resultKind
        ? stored!.bestStreak
        : 0;

    return 'Серія в цій грі: ${_streak.best}\n'
        'Рекорд: ${max(_streak.best, previousBest)}';
  }

  void _pauseForExitDialog() {
    if (!_hasEndlessMemory) return;
    if (!mounted || !_pauseOnExitDialog || _isExitPaused) return;

    _resumeStopwatchAfterExit = _stopwatch.isRunning;
    _stopwatch.stop();

    setState(() => _isExitPaused = true);
  }

  void _resumeAfterExitDialog() {
    if (!_hasEndlessMemory) return;
    if (!mounted || !_isExitPaused) return;

    if (_resumeStopwatchAfterExit) _stopwatch.start();

    setState(() => _isExitPaused = false);
  }

  void _finishOnQuit() {
    if (!mounted || _isFinishing) return;

    _markFinishing();

    unawaited(_finishAttempt(completionReason: TopicCompletionReason.quit));
  }
}
