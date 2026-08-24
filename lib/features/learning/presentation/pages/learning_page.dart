import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/theme/app_spacing.dart';
import 'package:school_tasks/core/theme/app_text_styles.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/evaluation/evaluation_calculator.dart';
import 'package:school_tasks/features/learning/domain/task_result.dart';
import 'package:school_tasks/features/learning/domain/topic.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_generator.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_result.dart';
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
  late final DateTime _startedAt;

  final TopicAttemptGenerator _attemptGenerator = TopicAttemptGenerator();
  @override
  void initState() {
    super.initState();

    _topic = LearningContent.topics.firstWhere(
      (topic) => topic.id == widget.topicId,
    );

    _startedAt = DateTime.now();

    _attempt = _attemptGenerator.generate(_topic);
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _attempt.currentTask;
    final result = currentTask.result;

    return AppScaffold(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Завдання ${_attempt.currentTaskIndex + 1} '
                'з ${_attempt.tasks.length}',
                style: AppTextStyles.body,
              ),

              const SizedBox(height: AppSpacing.lg),

              TaskWidget(
                task: currentTask.task,
                result: result,
                onTaskAnswered: _onTaskAnswered,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TopicAttempt _createAttempt() {
  //   final topic = LearningContent.topics.firstWhere(
  //     (topic) => topic.id == widget.topicId,
  //   );
  //
  //   return _attemptGenerator.generate(topic);
  // }

  void _onTaskAnswered(TaskResult<dynamic> result) {
    final currentTask = _attempt.currentTask;

    if (currentTask.isAnswered) {
      return;
    }

    _attempt.recordResult(result);

    if (_attempt.isFinished) {
      final topicResult = _attempt.getResult();

      final elapsedTime = DateTime.now().difference(_startedAt);
      debugPrint('STARTED: $_startedAt');
      debugPrint('NOW: ${DateTime.now()}');
      debugPrint('ELAPSED: ${elapsedTime.inMilliseconds} ms');
      final evaluation = _evaluationCalculator.calculate(
        topic: _topic,
        result: topicResult,
        elapsedTime: elapsedTime,
      );

      final evaluatedResult = TopicAttemptResult(
        totalTasks: topicResult.totalTasks,
        completedTasks: topicResult.completedTasks,
        correctTasks: topicResult.correctTasks,
        evaluation: evaluation,
      );

      context.pop(evaluatedResult);
      return;
    }

    setState(() {
      _attempt.moveToNextTask();
    });
  }
}
