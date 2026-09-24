import 'dart:async';

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
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_calculator.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_progression_mode.dart';
import 'package:school_tasks/features/learning/domain/topic_result_updater.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_progress_indicator.dart';
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

  AudioService get _audioService => ref.read(audioServiceProvider);

  Timer? _timer;
  Timer? _autoAdvanceTimer;

  int _completedProgressSteps = 0;
  bool _isFinishing = false;

  bool get _feedbackEnabled {
    return _topic.progressionMode != TopicProgressionMode.automatic;
  }

  @override
  void initState() {
    super.initState();

    _topic = LearningContent.getTopic(widget.topicId);
    _attempt = _attemptGenerator.generate(_topic);

    _stopwatch = Stopwatch()..start();

    _timer = Timer.periodic(const Duration(milliseconds: 250), (_) {
      if (!mounted || _isFinishing) {
        return;
      }

      final maximumTime = _topic.passingCriteria?.maximumTime;

      if (maximumTime != null && _stopwatch.elapsed >= maximumTime) {
        _handleTimeExpired();
        return;
      }

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoAdvanceTimer?.cancel();
    _stopwatch.stop();

    super.dispose();
  }

  int get _totalProgressSteps {
    var total = 0;

    for (final attemptTask in _attempt.tasks) {
      final task = attemptTask.task;

      if (task is MatchingTask) {
        total += task.pairs.length;
      } else {
        total += 1;
      }
    }

    return total;
  }

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
      onTaskAnswered: _onTaskAnswered,
      onProgressStep: _onProgressStep,
      onCorrectPair: _onCorrectPair,
      onIncorrectPair: _onIncorrectPair,
      feedbackEnabled: _feedbackEnabled,
      interactionScrollable: _topic.layout.interaction.scrollable,
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
                const SizedBox(width: 0),
                Expanded(
                  child: Opacity(
                    opacity: isManualAnswered ? 0.15 : 1.0,
                    child: LearningProgressIndicator(
                      progress: _completedProgressSteps,
                      totalSteps: _totalProgressSteps,
                      elapsed: _stopwatch.elapsed,
                      maximumTime: _topic.passingCriteria?.maximumTime,
                    ),
                  ),
                ),
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

    if (_feedbackEnabled && currentTask.task is! MatchingTask) {
      if (result.isCorrect) {
        _audioService.playSuccess();
      } else {
        _audioService.playFailure();
      }
    }

    if (currentTask.task is! MatchingTask) {
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
      _autoAdvanceTimer?.cancel();

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

    _isFinishing = true;

    _timer?.cancel();
    _timer = null;

    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;

    _stopwatch.stop();

    if (!mounted) {
      return;
    }

    await showDialog<void>(
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

    if (!mounted) {
      return;
    }

    await _finishAttempt();
  }

  Future<void> _finishAttempt() async {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;

    _stopwatch.stop();

    final elapsedTime = _stopwatch.elapsed;

    final topicResult = _attempt.getResult(duration: elapsedTime);

    final evaluation = _evaluationCalculator.calculate(
      topic: _topic,
      result: topicResult,
      elapsedTime: elapsedTime,
    );

    final evaluatedResult = TopicAttemptResult(
      totalTasks: topicResult.totalTasks,
      completedTasks: topicResult.completedTasks,
      accuracy: topicResult.accuracy,
      duration: topicResult.duration,
      evaluation: evaluation,
    );

    final previousResult = ref.read(
      learningResultsControllerProvider,
    )[_topic.id];

    final updatedResult = _topicResultUpdater.update(
      attempt: evaluatedResult,
      currentAt: DateTime.now(),
      previous: previousResult,
    );

    final preferences = await ref.read(appPreferencesProvider.future);

    await preferences.setTopicResult(_topic.id, updatedResult);

    if (!mounted) {
      return;
    }

    ref
        .read(learningResultsControllerProvider.notifier)
        .setResult(_topic.id, updatedResult);

    // Нормальне завершення теми — це дозволений вихід,
    // тому confirmation через onExit показувати не потрібно.
    widget.exitGuard.allowExit = true;

    if (kIsWeb) {
      Router.neglect(context, () => context.go(AppRoutes.home));
    } else {
      context.pop();
    }
  }

  void _moveToNextTask() {
    if (!mounted) {
      return;
    }

    setState(() {
      _attempt.moveToNextTask();
    });
  }

  void _onCorrectPair() {
    if (!_feedbackEnabled) {
      return;
    }

    _audioService.playSuccess();
  }

  void _onIncorrectPair() {
    if (!_feedbackEnabled) {
      return;
    }

    _audioService.playFailure();
  }
}
