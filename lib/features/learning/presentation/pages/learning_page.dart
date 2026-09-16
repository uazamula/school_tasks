import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
import 'package:school_tasks/features/learning/presentation/widgets/learning_progress_indicator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_widget.dart';
import 'package:school_tasks/features/learning/presentation/widgets/topic_layout_widget.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key, required this.topicId});

  final String topicId;

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late final TopicAttempt _attempt;
  late final Topic _topic;

  final EvaluationCalculator _evaluationCalculator =
      const EvaluationCalculator();

  final TopicAttemptGenerator _attemptGenerator = TopicAttemptGenerator();
  final AudioService _audioService = AudioService();

  late final Stopwatch _stopwatch;

  Timer? _timer;
  Timer? _autoAdvanceTimer;

  int _completedProgressSteps = 0;

  /// Feedback доступний тільки для режимів,
  /// у яких користувач має побачити результат відповіді.
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
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _autoAdvanceTimer?.cancel();
    _stopwatch.stop();
    _audioService.dispose();

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
      result: result,
      onTaskAnswered: _onTaskAnswered,
      onProgressStep: _onProgressStep,
      onCorrectPair: _onCorrectPair,
      feedbackEnabled: _feedbackEnabled,
    );

    return AppScaffold(
      child: SafeArea(
        child: Column(
          children: [
            Opacity(
              opacity: isManualAnswered ? 0.15 : 1.0,
              child: LearningProgressIndicator(
                progress: _completedProgressSteps,
                totalSteps: _totalProgressSteps,
                elapsed: _stopwatch.elapsed,
              ),
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

    if (_feedbackEnabled &&
        currentTask.task is! MatchingTask &&
        result.isCorrect) {
      _audioService.playSuccess();
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
      _finishAttempt();
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

  void _finishAttempt() {
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

    context.pop(evaluatedResult);
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
}
