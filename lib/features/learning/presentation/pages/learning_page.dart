import 'package:flutter/material.dart';
import 'package:school_tasks/core/widgets/app_scaffold.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/learning_task.dart';
import '../../domain/learning_task_generator.dart';
import '../../domain/task_result.dart';
import '../widgets/choice_task_widget.dart';

class LearningPage extends StatefulWidget {
  const LearningPage({super.key, required this.topicId});

  final String topicId;

  @override
  State<LearningPage> createState() => _LearningPageState();
}

class _LearningPageState extends State<LearningPage> {
  late final LearningTask _task;
  final LearningTaskGenerator _generator = LearningTaskGenerator();

  TaskResult<int>? _result;

  @override
  void initState() {
    super.initState();

    _task = _generator.generateAdditionWithin10();
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final isAnswered = result?.isAnswered ?? false;

    return AppScaffold(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChoiceTaskWidget(
              task: _task,
              result: result,
              onAnswerSelected: _onAnswerSelected,
            ),

            if (isAnswered) ...[
              const SizedBox(height: AppSpacing.lg),

              Text(
                result!.isCorrect ? 'Правильно!' : 'Неправильно!',
                style: AppTextStyles.title,
              ),

              const SizedBox(height: AppSpacing.lg),

              FilledButton(
                onPressed: _finishTask,
                child: const Text('Завершити'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onAnswerSelected(int answer) {
    setState(() {
      _result = _task.checkAnswer(answer);
    });
  }

  void _finishTask() {
    Navigator.of(context).pop();
  }
}
