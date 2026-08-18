import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';
import 'package:school_tasks/features/learning/domain/numeric_input_task.dart';
import 'package:school_tasks/features/learning/presentation/widgets/task_widget.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/attempt_task.dart';
import '../../domain/learning_task_generator.dart';
import '../../domain/topic_attempt.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key, required this.topicId});
  final String topicId;
  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late final TopicAttempt _attempt;

  final LearningTaskGenerator _generator = LearningTaskGenerator();

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

  //-------------temporary-------------
  TopicAttempt _createAttempt() {
    return TopicAttempt(
      tasks: [
        AttemptTask(task: _generator.generateAdditionWithin10()),
        AttemptTask(task: _generator.generateAdditionWithin10()),
        AttemptTask(
          task: NumericInputTask(condition: '3 + 5 = ?', correctAnswer: 8),
        ),
      ],
    );
  }
  //-------------temporary-------------

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
