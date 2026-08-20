import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';
import 'package:school_tasks/features/learning/data/learning_content.dart';
import 'package:school_tasks/features/learning/domain/topic_attempt_generator.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_widget.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/topic_attempt.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key, required this.topicId});
  final String topicId;
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late final TopicAttempt _attempt;

  final TopicAttemptGenerator _attemptGenerator = TopicAttemptGenerator();
  @override
  void initState() {
    super.initState();

    _attempt = _createAttempt();
  }

  @override
  Widget build(BuildContext context) {
    final currentTask = _attempt.currentTask;
    final result = currentTask.result;

    return AppScaffold(
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
              onAnswerSelected: _onAnswerSelected,
            ),

            if (result != null) ...[
              const SizedBox(height: AppSpacing.lg),

              Text(
                result.isCorrect ? 'Правильно!' : 'Неправильно!',
                style: AppTextStyles.title,
              ),

              const SizedBox(height: AppSpacing.lg),

              FilledButton(
                onPressed: _finishCurrentTask,
                child: Text(
                  _attempt.isFinished ? 'Завершити тему' : 'Наступне',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  TopicAttempt _createAttempt() {
    final topic = LearningContent.topics.firstWhere(
      (topic) => topic.id == widget.topicId,
    );

    return _attemptGenerator.generate(
      topic,
      taskData: LearningContent.additionWithin10Data,
    );
  }

  void _onAnswerSelected(int answer) {
    final currentTask = _attempt.currentTask;

    if (currentTask.isAnswered) {
      return;
    }

    setState(() {
      _attempt.recordResult(currentTask.task.checkAnswer(answer));
    });
  }

  void _finishCurrentTask() {
    if (!_attempt.isFinished) {
      setState(() {
        _attempt.moveToNextTask();
      });

      return;
    }

    final result = _attempt.getResult();

    context.pop(result);
  }
}
