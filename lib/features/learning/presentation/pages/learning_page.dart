import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_generator.dart';
import 'package:school_tasks/features/learning/domain/attempts/topic_attempt_result.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_calculator.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/tasks/matching_task.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/presentation/widgets/learning_progress_indicator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_widget.dart';

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

  late final Stopwatch _stopwatch;
  Timer? _timer;

  int _completedProgressSteps = 0;

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

    return AppScaffold(
      child: Column(
        children: [
          LearningProgressIndicator(
            progress: _completedProgressSteps,
            totalSteps: _totalProgressSteps,
            elapsed: _stopwatch.elapsed,
          ),

          const SizedBox(height: AppSpacing.lg),

          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: TaskWidget(
                  task: currentTask.task,
                  result: result,
                  onTaskAnswered: _onTaskAnswered,
                  onProgressStep: _onProgressStep,
                ),
              ),
            ),
          ),
        ],
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

    // Для всіх звичайних завдань одна прийнята відповідь
    // дорівнює одному кроку прогресу.
    if (currentTask.task is! MatchingTask) {
      _completedProgressSteps++;
    }

    if (_attempt.isFinished) {
      _finishAttempt();
      return;
    }

    setState(() {
      _attempt.moveToNextTask();
    });
  }

  void _finishAttempt() {
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
}
